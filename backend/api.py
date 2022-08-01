# from flask import Flask
from fastapi import FastAPI, Response, status
from uvicorn import run
from pydantic import BaseModel
from typing import Optional

from login_handler import db_handler as db_emp_det
from booking_handler import db_handler as db_book_inf

import json
import datetime
import re

class LoginRequest(BaseModel):
    uid: int
    password: str


class NewBooking(BaseModel):
    uid: int
    travelPurpose: str
    expectedDistance: float
    pickUpTimeDate: str
    pickupVenue: str
    arrivalTimeDate: str
    additionalInfo: Optional[str | None]
    reqDateTime: str

class Base(BaseModel):
    uid: int

app = FastAPI()

@app.get('/')
def route():
    return "server functional"


@app.post('/login')
def home(req: LoginRequest, response : Response):
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


@app.post('/newbooking')
def newbooking(req: NewBooking):
    # x = x.split(',  ')
    # x.reverse()
    # x = ' '.join(x)
    regex = '^(\d\d:\d\d [A|P]M).+(\d\d)-(\d\d)-([\d]+)'
    temp = re.findall(regex, req.pickUpTimeDate)
    req.pickUpTimeDate = '-'.join(temp[0][-1:-4:-1]) + ' ' + temp[0][0]

    temp = re.findall(regex, req.arrivalTimeDate)
    req.arrivalTimeDate = '-'.join(temp[0][-1:-4:-1]) + ' ' + temp[0][0]

    temp = re.findall('^([\d]+-\d\d-\d\d).(\d\d:\d\d)', req.reqDateTime)
    req.reqDateTime = ' '.join(temp[0])
    try:
        db_book_inf().write(req)
    except err:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.put('/approval/{bid}/{val}')
def setstatus(val: bool, bid: int):
    try:
        db_book_inf().set_approval_status(val, bid)
    except:
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.get('/history/{uid}')
def history(uid : int) -> list:
    # print("inside function")
    try:
        # print(uid, type(uid))
        rows_list = db_book_inf().read(uid)
        # for row in rows_list:
        #     print(row)
        #     print(json.dumps(str(row)))
        # print(rows_list)
        # for row in rows_list:
        #     print(row.emp_id, row.booking_id)
        json_list = []
        for row in rows_list:
            # print(row.arrival_time_date)
            data = {'uid' : row.emp_id,
            'travelPurpose': row.trav_purpose,
            'expectedDistance': row.expected_dist,
            'pickUpTimeDate': str(row.pickup_date_time),
            'pickupVenue': row.pickup_venue,
            'arrivalTimeDate': str(row.arrival_date_time),
            'additionalInfo': row.additional_info,
            'approvalStatus': row.approval_status}
            json_list.append(data)

        return json_list
    except:
        # response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        # return "Internal Server Error"
        pass

if __name__ == '__main__':
    run(app, port=5000)
    # newbooking(None)
    # print(history(1))