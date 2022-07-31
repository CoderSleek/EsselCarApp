# from flask import Flask
from fastapi import FastAPI, Response, status
from uvicorn import run
from pydantic import BaseModel
from typing import Optional

from login_handler import db_handler as db_emp_det
import json
from datetime import datetime, date

class LoginRequest(BaseModel):
    uid: int
    password: str


class NewBooking(BaseModel):
    uid: int
    travelPurpose: str
    pickUpTimeDate: str
    arrivalTimeDate: str
    additionalInfo: Optional[str | None]


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
                'id': row.emp_id,
                'name': row.emp_name,
                'email': row.emp_email,
                'mng_email' : row.mng_email
            }
        else:
            response.status_code = status.HTTP_401_UNAUTHORIZED
            return "Invalid Credentials"
    except err:
        # response.status_code = status.HTTP_400_BAD_REQUEST
        print(err)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return "Internal Server Error"


@app.post('/newbooking')
def newbooking(req: NewBooking):
    print(req)


if __name__ == '__main__':
    # print(datetime.now(), date.today())
    run(app, port=5000)
    # print(home({'uid': 1, 'password': '123456'} , None))