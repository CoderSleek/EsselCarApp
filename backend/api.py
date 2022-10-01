# from flask import Flask
from fastapi import FastAPI, Response, status, Request, HTTPException, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.middleware.cors import CORSMiddleware
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles

from uvicorn import run
from pydantic import BaseModel
from typing import Optional
from pathlib import Path

import jwt_handler as jwt
from mail import email_manager, email_requests
from login_handler import db_handler as db_emp_det
from booking_handler import db_handler as db_book_inf
from vehicle_handler import db_handler as db_veh_info
# from fake_db import db_emp_det, db_book_inf

import json
from datetime import datetime, date
import re

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


class PageNumber(BaseModel):
    num: int


class tokenType(BaseModel):
    token: str


class vehicleInfo(BaseModel):
    bookingID: int

class setBookingStatus(BaseModel):
    bookingID:int
    status: bool
    comments: str


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount('/static', StaticFiles(
    # directory="C:/Users/user/Documents/codes/carbookapp/website/static"),
    directory="../website"),
    name="static")

templates = Jinja2Templates(
    # directory='C:/Users/user/Documents/codes/carbookapp/website')
    directory="../website")


@app.get('/')
def defaultRoute():
    return "server functional"


@app.post('/login', tags=['Employee'])
def employeeLogin(req: LoginRequest, response : Response):
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
                # 'mng_email' : row.mng_email,
                'position': row.position
            }
        else:
            response.status_code = status.HTTP_401_UNAUTHORIZED
            return "Invalid Credentials"
    except err:
        # response.status_code = status.HTTP_400_BAD_REQUEST
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.post('/newbooking', tags=['Employee'])
def createNewbooking(req: NewBooking, response: Response):
    # x = x.split(',  ')
    # x.reverse()
    # x = ' '.join(x)
    try:
        regex = '^(\d\d:\d\d [A|P]M).+(\d\d)-(\d\d)-([\d]+)'
        temp = re.findall(regex, req.pickupDateTime)
        req.pickupDateTime = '-'.join(temp[0][-1:-4:-1]) + ' ' + temp[0][0]

        temp = re.findall(regex, req.arrivalDateTime)
        req.arrivalDateTime = '-'.join(temp[0][-1:-4:-1]) + ' ' + temp[0][0]

        # temp = re.findall('^([\d]+-\d\d-\d\d).(\d\d:\d\d)', req.reqDateTime)
        # req.reqDateTime = ' '.join(temp[0])
        # temp = re.findall('^([\d]+)-(\d\d)-(\d\d).*(\d\d):(\d\d):(\d\d)', str(datetime.datetime.now()))
        req.reqDateTime = str(datetime.now()).split('.')[0]
        manager_details = db_emp_det().get_mng_details(req.uid)
        req.managerID = manager_details.emp_id
    except Exception as e:
        print(e)
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
            email_manager.email_handler(data_packet, email_requests.NEW_BOOKING_REQUEST_TO_MANAGER)
    except Exception as e:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.put('/approval', tags=['Employee'])
def setResponseStatus(res: setBookingStatus, response: Response):
    if res.comments != '':
        res.comments = res.comments.strip(' ')
        if not re.match('^[\w .-]+$',res.comments):
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
        email_manager.email_handler(data_packet, email_requests.BOOKING_REQUEST_UPDATE_TO_EMPLOYEE)

        if res.status:
            admin_details_list = db_emp_det().get_admin_details(emp_details.emp_loc)
            for single_admin in admin_details_list:
                data_packet = {
                    'admName': single_admin.emp_name,
                    'empName': emp_details.emp_name,
                    'receiverEmail' : single_admin.emp_email,
                }
                email_manager.email_handler(data_packet, email_requests.BOOKING_REQUEST_UPDATE_TO_ADMIN)

        response.status_code = status.HTTP_202_ACCEPTED
        return "Status Set"
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.get('/history/{uid}', tags=['Employee'])
def retrieveUserHistories(uid : int, response: Response) -> list:
    try:
        rows_list = db_book_inf().read(uid)
        for i in range(len(rows_list)):
            pickupDateTime = rows_list[i].pickup_date_time.strftime("%I:%M %p %d-%m-%Y")
            arrivalDateTime = rows_list[i].arrival_date_time.strftime("%I:%M %p %d-%m-%Y")
            adminApproval = rows_list[i].approval_status and db_veh_info().get_time_data(rows_list[i].booking_id)
            
            rows_list[i] = {
            'uid' : rows_list[i].emp_id,
            'travelPurpose': rows_list[i].trav_purpose,
            'expectedDistance': rows_list[i].expected_dist,
            'pickupDateTime': pickupDateTime,
            'pickupVenue': rows_list[i].pickup_venue,
            'arrivalDateTime': arrivalDateTime,
            'additionalInfo': rows_list[i].additional_info,
            'approvalStatus': rows_list[i].approval_status,
            'isAdminApproved': adminApproval
            }
            print(rows_list[i])

        return rows_list
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.post('/admincredcheck', tags=['Admin'])
def adminCredentialValidation(req: AdminLoginRequest) -> str:
    if req.uname == 'admin' and req.password == 'admin':
        return jwt.signJWT(req.uname, req.password)


@app.get('/adminpage', tags=['Admin'])
def adminContentPage(token : str, response: Response, request: Request):
    try:
        package = jwt.decodeJWT(token)
        if package is not None and package['userName'] == 'admin' and package['password'] == 'admin':
            return templates.TemplateResponse("adminpage.html", {"request":request})
        else:
            response.status_code = status.HTTP_403_FORBIDDEN
            return templates.TemplateResponse("error.html", {"request": request})
    except Exception as err:
        response.status_code = status.HTTP_403_FORBIDDEN
        return templates.TemplateResponse("error.html", {"request": request})
    

@app.get('/adminlogin', tags=['Admin'])
def adminLoginPage(request: Request):
    return templates.TemplateResponse("admin.html", {"request":request})


@app.post('/getbookingrequests', tags=['Admin'])
def retrieveBookingRequests(page : PageNumber):

    row_list = list
    db_rows = db_book_inf().get_rows()
    for i in range(page.num):
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

        row_list[i] = {
            'bookingID': row_list[i].booking_id,
            'empID' : row_list[i].emp_id,
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
def dispatchVehiclePacket(req: VehicleInfoPacket, response : Response):
    if not validate_packet([x for x in list(req.__dict__.values()) if not isinstance(x, date)]):
        response.status_code = status.HTTP_400_BAD_REQUEST
        return

    try:
        db_veh_info().write_admin_packet(req)
        booking_details = db_book_inf().get_row_by_booking_id(req.bookingID)
        emp_details = db_emp_det().read(booking_details.emp_id)
        data_packet = {
            'empName' : emp_details.emp_name,
            'travPurpose' : booking_details.trav_purpose,
            'receiverEmail' : emp_details.emp_email,
        }
        email_manager.email_handler(data_packet, email_requests.ADMIN_UPDATE_EMAIL_TO_EMPLOYEE)
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR


@app.post('/getvehicleinfo', tags=['Admin'])
async def retrieveVehicleData(req: vehicleInfo, response: Response):
    try:
        vehicle_info = db_veh_info().get_single_booking(req.bookingID)

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
            'inTime': vehicle_info.in_time,
            'outTime': vehicle_info.out_time,
        }
        return return_token
    except Exception as e:
        status_code = status.HTTP_500_INTERNAL_SERVER_ERROR


@app.get('/getmanagerrequests', tags=['Employee'])
def getManagerRequests(emp_id: int, response: Response):
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

    except Exception as e:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR


def validate_packet(req):
    special_char_regex = re.compile('^[A-Za-z0-9 -]*$')
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


if __name__ == '__main__':
    run(app, port=5000)