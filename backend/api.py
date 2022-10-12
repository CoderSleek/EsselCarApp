from fastapi import FastAPI, Response, status, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles

from uvicorn import run
from pydantic import BaseModel
from typing import Optional

import jwt_handler as jwt
from mail import Email_manager, Email_requests
# from login_handler import db_handler as db_emp_det
# from booking_handler import db_handler as db_book_inf
# from vehicle_handler import db_handler as db_veh_info
from fake_db import db_book_inf, db_emp_det, db_veh_info

from datetime import datetime, date, time
from re import findall, match, compile as compile_
from traceback import format_exc

class LoginRequest(BaseModel):
    uid: int
    password: str


class NewBooking(BaseModel):
    uid: int
    travelPurpose: str
    expectedDistance: float
    pickupDateTime: str
    pickupVenue: str
    arrivalDateTime: str
    additionalInfo: Optional[str | None]
    reqDateTime: Optional[str]
    managerID: Optional[int]


class AdminLoginRequest(BaseModel):
    uname: str
    password: str


class VehicleInfoPacket(BaseModel):
    bookingID: int
    vehRegNum: str
    vehModel: str
    licenseExpDate: date
    insuranceExpDate: date
    pucExpDate: date
    driverName: str
    driverAddress: str
    licenseNum: str
    driverContact: int
    travAgentContact: Optional[int | None]


class SetBookingStatus(BaseModel):
    bookingID: int
    status: bool
    comments: str


class TimeData(BaseModel):
    bookingID: int
    inTime: str
    outTime: str
    inDist: float
    outDist: float


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount('/static', StaticFiles(directory="../website"), name="static")

templates = Jinja2Templates(directory="../website")


@app.get('/')
def defaultRoute():
    return "server functional"


@app.post('/login', tags=['Employee'])
def employeeLogin(req: LoginRequest, response : Response) -> dict:
    try:
        db = db_emp_det()
        row = db.read(req.uid) # gets a single row as a named tuple from db

        if row is None:
            response.status_code = status.HTTP_404_NOT_FOUND
            return "User Does not exist"

        if req.password == row.password:
            return {
                'uid': row.emp_id,
                'name': row.emp_name,
                'email': row.emp_email,
                'position': row.position
            }
        else:
            response.status_code = status.HTTP_401_UNAUTHORIZED
            return "Invalid Credentials"

    except Exception as err:
        _write_to_log_file(err)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.post('/newbooking', tags=['Employee'])
def createNewbooking(req: NewBooking, response: Response) -> dict:
    try:
        regex = '^(\d\d:\d\d [A|P]M).+(\d\d)-(\d\d)-([\d]+)'
        temp = findall(regex, req.pickupDateTime)
        req.pickupDateTime = '-'.join(temp[0][-1:-4:-1]) + ' ' + temp[0][0]

        temp = findall(regex, req.arrivalDateTime)
        req.arrivalDateTime = '-'.join(temp[0][-1:-4:-1]) + ' ' + temp[0][0]

        req.reqDateTime = str(datetime.now()).split('.')[0]
        manager_details = db_emp_det().get_mng_details(req.uid)
        req.managerID = manager_details.emp_id
        print(req.arrivalDateTime, req.pickupDateTime, req.reqDateTime)
    except Exception as err:
        _write_to_log_file(err)
        response.status_code = status.HTTP_406_NOT_ACCEPTABLE
        return "Bad Request"
        
    try:
        approval_status = db_book_inf().write(req)

        if approval_status:
            data_packet = {
                'mngName': manager_details.emp_name,
                'empName': db_emp_det().read(req.uid).emp_name,
                'travPurpose': req.travelPurpose,
                'receiverEmail': manager_details.emp_email
            }
            Email_manager.email_handler(data_packet, Email_requests.NEW_BOOKING_REQUEST_TO_MANAGER)

    except Exception as err:
        _write_to_log_file(err)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.put('/approval', tags=['Employee'])
def setResponseStatus(res: SetBookingStatus, response: Response) -> dict:
    if res.comments != '':
        res.comments = res.comments.strip(' ')
        if not match('^[\w .-]+$',res.comments):
            response.status_code = status.HTTP_406_NOT_ACCEPTABLE
            return "Invalid Comment"

    try:
        db_book_inf().set_approval_status(res.bookingID, res.status)
        
        booking_details = db_book_inf().get_row_by_booking_id(res.bookingID)
        emp_details = db_emp_det().read(booking_details.emp_id)
        data_packet = {
            'empName': emp_details.emp_name,
            'travPurpose': booking_details.trav_purpose,
            'status': res.status,
            'additionalComments': res.comments,
            'receiverEmail': emp_details.emp_email
        }
        Email_manager.email_handler(data_packet, Email_requests.BOOKING_REQUEST_UPDATE_TO_EMPLOYEE)

        if res.status:
            admin_details_list = db_emp_det().get_admin_details(emp_details.emp_loc)
            for single_admin in admin_details_list:
                data_packet = {
                    'admName': single_admin.emp_name,
                    'empName': emp_details.emp_name,
                    'receiverEmail' : single_admin.emp_email,
                }
                Email_manager.email_handler(data_packet, Email_requests.BOOKING_REQUEST_UPDATE_TO_ADMIN)

        response.status_code = status.HTTP_202_ACCEPTED
        return "Status Set"

    except Exception as err:
        _write_to_log_file(err)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.get('/history/{uid}', tags=['Employee'])
def retrieveUserHistories(uid : int, response: Response) -> list or dict:
    try:
        rows_list = db_book_inf().read(uid)
        for i in range(len(rows_list)):
            pickupDateTime = rows_list[i].pickup_date_time.strftime("%I:%M %p %d-%m-%Y")
            arrivalDateTime = rows_list[i].arrival_date_time.strftime("%I:%M %p %d-%m-%Y")
            canFillTime = db_veh_info().get_time_data(rows_list[i].booking_id)
            
            rows_list[i] = {
            'bookingID' : rows_list[i].booking_id,
            'travelPurpose': rows_list[i].trav_purpose,
            'expectedDistance': rows_list[i].expected_dist,
            'pickupDateTime': pickupDateTime,
            'pickupVenue': rows_list[i].pickup_venue,
            'arrivalDateTime': arrivalDateTime,
            'additionalInfo': rows_list[i].additional_info,
            'approvalStatus': rows_list[i].approval_status,
            'canFillTime': canFillTime
            }

        return rows_list
    except Exception as e:
        _write_to_log_file(err)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.post('/admincredcheck', tags=['Admin'])
def adminCredentialValidation(req: AdminLoginRequest, response: Response) -> dict:
    admins_list = db_emp_det().get_all_admin()

    try:
        for admin in admins_list:
            if req.uname == admin.emp_name and req.password == admin.password:
                return jwt.signJWT(admin.emp_id, admin.password)
        else:
            response.status_code = status.HTTP_401_UNAUTHORIZED
            return "Unauthorized"

    except Exception as err:
        _write_to_log_file(err)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return


@app.get('/adminpage', tags=['Admin'])
def adminContentPage(request: Request, response: Response) -> templates.TemplateResponse:
    return templates.TemplateResponse("adminpage.html", {"request": request})


@app.get('/unauthorized', tags=['Admin'])
def redirect(request: Request, response: Response) -> templates.TemplateResponse:
    return templates.TemplateResponse("error.html", {"request": request}, status_code=308)


@app.get('/adminlogin', tags=['Admin'])
def adminLoginPage(request: Request, response: Response) -> templates.TemplateResponse:
    return templates.TemplateResponse("admin.html", {"request":request})


@app.post('/getbookingrequests', tags=['Admin'])
def retrieveBookingRequests(json : dict, request: Request, response: Response) -> dict or list:
    token = request.headers.get('authorization')

    if not _validate_token(token):
        response.status_code = status.HTTP_401_UNAUTHORIZED
        return "unauthorized"

    row_list = []
    db_rows = db_book_inf().get_rows()

    for i in range(json['num']):
        row_list = []
        for j in range(10):
            try:
                row_list.append(db_rows.__next__())
            except:
                break

    for i in range(len(row_list)):
        pickupDateTime = row_list[i].pickup_date_time.strftime("%I:%M %p %d-%m-%Y")
        arrivalDateTime = row_list[i].arrival_date_time.strftime("%I:%M %p %d-%m-%Y")
        requestDateTime = row_list[i].request_date_time.strftime("%I:%M %p %d-%m-%Y")
        empName = db_emp_det().read(row_list[i].emp_id).emp_name

        row_list[i] = {
            'bookingID': row_list[i].booking_id,
            'empName' : empName,
            'travelPurpose': row_list[i].trav_purpose,
            'expectedDist': row_list[i].expected_dist,
            'pickupDateTime': pickupDateTime,
            'pickupVenue': row_list[i].pickup_venue,
            'arrivalDateTime': arrivalDateTime,
            'additionalInfo': row_list[i].additional_info,
            'mngID': row_list[i].mng_id,
            'isApproved': row_list[i].approval_status,
            'requestDateTime': requestDateTime,
            'hasInfoFilled': db_veh_info().filled(row_list[i].booking_id)
        }
        
    return row_list


@app.post('/newvehicleinfo', tags=['Admin'])
def dispatchVehiclePacket(req: VehicleInfoPacket, request: Request, response : Response) -> dict:
    token = request.headers.get('authorization')

    if not _validate_token(token):
        response.status_code = status.HTTP_401_UNAUTHORIZED
        return "unauthorized"

    if not _validate_packet([x for x in list(req.__dict__.values()) if not isinstance(x, date)]):
        response.status_code = status.HTTP_400_BAD_REQUEST
        return "invalid packet"

    try:
        db_veh_info().write_admin_packet(req)
        booking_details = db_book_inf().get_row_by_booking_id(req.bookingID)
        emp_details = db_emp_det().read(booking_details.emp_id)
        data_packet = {
            'empName' : emp_details.emp_name,
            'travPurpose' : booking_details.trav_purpose,
            'receiverEmail' : emp_details.emp_email,
        }
        Email_manager.email_handler(data_packet, Email_requests.ADMIN_UPDATE_EMAIL_TO_EMPLOYEE)

    except Exception as err:
        _write_to_log_file(err)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return


@app.post('/getvehicleinfo', tags=['Admin'])
async def retrieveVehicleData(json: dict, request: Request, response: Response) -> dict:
    token = request.headers.get('authorization')

    if not _validate_token(token):
        response.status_code = status.HTTP_401_UNAUTHORIZED
        return "Unauthorized"

    try:
        vehicle_info = db_veh_info().get_single_booking(json['bookingID'])

        if vehicle_info == None:
            response.status_code = status.HTTP_404_NOT_FOUND
            return "Bad Request"

        return_token = {
            'bookingID': vehicle_info.booking_id,
            'vehRegNum': vehicle_info.veh_reg_num,
            'vehModel': vehicle_info.veh_model,
            'licenseExpDate': vehicle_info.license_expiry,
            'insuranceExpDate': vehicle_info.insurance_validity,
            'pucExpDate': vehicle_info.puc_expiry,
            'driverName': vehicle_info.driver_name,
            'driverAddress': vehicle_info.driver_contact,
            'driverContact': vehicle_info.driver_address,
            'licenseNum': vehicle_info.license_num,
            'travAgentContact': vehicle_info.trav_agent_contact,
            'inDist': vehicle_info.start_dist,
            'outDist': vehicle_info.end_dist,
            'inTime': None if vehicle_info.in_time is None else vehicle_info.in_time.strftime('%I:%M %p'),
            'outTime': None if vehicle_info.out_time is None else vehicle_info.out_time.strftime('%I:%M %p'),
        }
        return return_token

    except Exception as err:
        _write_to_log_file(err)
        status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return


@app.get('/getmanagerrequests', tags=['Employee'])
def getManagerRequests(emp_id: int, response: Response) -> list or dict:
    rows = db_book_inf().get_mng_req(emp_id)

    if(len(rows) == 0):
        return []

    try:
        for index in range(len(rows)):
            pickupDateTime = rows[index].pickup_date_time.strftime("%I:%M %p %d-%m-%Y")
            arrivalDateTime = rows[index].arrival_date_time.strftime("%I:%M %p %d-%m-%Y")

            rows[index] = {
                'bookingID': rows[index].booking_id,
                'empID': rows[index].emp_id,
                'travelPurpose': rows[index].trav_purpose,
                'expectedDist': rows[index].expected_dist,
                'pickupDateTime': pickupDateTime,
                'pickupVenue': rows[index].pickup_venue,
                'arrivalDateTime': arrivalDateTime,
                'additionalInfo': rows[index].additional_info,
                'isApproved': rows[index].approval_status
            }
        return rows

    except Exception as err:
        _write_to_log_file(err)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return


@app.put('/travelData', tags=['Employee'])
def insertTimeData(req: TimeData, response: Response) -> dict:
    req.inTime = datetime.strptime(req.inTime, '%I:%M %p').time()
    req.outTime = datetime.strptime(req.outTime, '%I:%M %p').time()

    try:
        db_veh_info().write_time_data(req)
        response.status_code = status.HTTP_202_ACCEPTED
        return "success"
    except Exception as err:
        _write_to_log_file(err)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return


def _validate_packet(req) -> bool:
    special_char_regex = compile_('^[A-Za-z0-9 -]*$')
    list_of_char_limits = [50, 100, 50, 200, 50]

    if not db_book_inf().get_approval_status(req[0]):
        return False

    for index in range(1, len(req)-2):
        req[index] = req[index].strip(' ')
        if len(req[index]) == 0 or (not special_char_regex.match(req[index])) or (
            list_of_char_limits[index-1] < len(req[index])):
            return False

    for index in range(len(req)-2,len(req)):
        if (not (isinstance(req[index], int) and len(str(req[index])) == 10)) and (req[index] is not None):
            return False

    return True


def _validate_token(token) -> bool:
    if token == '':
        return False

    try:
        package = jwt.decodeJWT(token)

        if package is None:
            return False

        admin = db_emp_det().read(package['userID'])

        if package['password'] == admin.password:
            return True
        
        return False
    except Exception as err:
        _write_to_log_file(err)
        return False


def _write_to_log_file(err: Exception) -> None:
    with open('logfile.log', 'a') as logfile:
        exception_detail = format_exc().split('\n')[1:]
        print(' '.join(exception_detail), file=logfile)


if __name__ == '__main__':
    run(app, port=5000)