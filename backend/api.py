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
    driverContact: int
    licenseNum: str
    travAgentContact: Optional[int | None]


class PageNumber(BaseModel):
    num: int


class tokenType(BaseModel):
    token: str


class vehicleInfo(BaseModel):
    bookingID: int


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
                'mng_email' : row.mng_email
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
    except:
        response.status_code = status.HTTP_406_NOT_ACCEPTABLE
        return "Bad Request"
        
    try:
        db_book_inf().write(req)
    except err:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.put('/approval/{bid}/{val}', tags=['Employee'])
def setResponseStatus(val: bool, bid: int, response: Response):
    try:
        db_book_inf().set_approval_status(val, bid)
    except:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.get('/history/{uid}', tags=['Employee'])
def retrieveUserHistories(uid : int, response: Response) -> list:
    try:
        rows_list = db_book_inf().read(uid)
        json_list = []
        for row in rows_list:
            data = {'uid' : row.emp_id,
            'travelPurpose': row.trav_purpose,
            'expectedDistance': row.expected_dist,
            'pickupDateTime': str(row.pickup_date_time),
            'pickupVenue': row.pickup_venue,
            'arrivalDateTime': str(row.arrival_date_time),
            'additionalInfo': row.additional_info,
            'approvalStatus': row.approval_status}
            json_list.append(data)

        return json_list
    except:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.post('/admincredcheck', tags=['Admin'])
def adminCredentialValidation(req: AdminLoginRequest) -> str:
    if req.uname == 'admin' and req.password == 'admin':
        return jwt.signJWT(req.uname, req.password)


@app.get('/adminpage', tags=['Admin'])
def adminContentPage(token : tokenType, request: Request):
    # return templates.TemplateResponse("index.html", {"request":request})
    # print(token.token)
    try:
        package = jwt.decodeJWT(token)
        if package['userName'] == 'admin' and package['password'] == 'admin':
            return templates.TemplateResponse("adminpage.html", {"request":request})
        else:
            response.status_code = status.HTTP_403_FORBIDDEN
            return templates.TemplateResponse("error.html", {"request": request})
    except err:
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

    print('after if')
    try:
        pass
        # db_veh_info().write_admin_packet(req)
    except Exception as e:
        print(e)
        # response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR


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


def validate_packet(req):
    special_char_regex = re.compile('^[A-Za-z0-9 -]*$')
    list_of_char_limits = [50, 100, 50, 200, 50, 10, 10]

    if not db_book_inf().get_approval_status(req[0]):
        return False

    for index in range(1, len(req)-2):
        if len(req[index]) == 0 or (not special_char_regex.match(req[index])) or (
            list_of_char_limits[index] < len(req[index])):
            return False
    
    for index in range(len(req)-2,len(req)):
        if (not (isinstance(req[index], int) and len(str(req[index])) == 10)) and (req[index] is not None):
            return False

    return True


if __name__ == '__main__':
    run(app, port=5000)