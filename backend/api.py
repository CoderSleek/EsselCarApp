# from flask import Flask
from fastapi import FastAPI
from uvicorn import run
from pydantic import BaseModel
from typing import Optional

from login_handler import db_handler as db_emp_det
import json

class LoginRequest(BaseModel):
    uid: int
    password: str


app = FastAPI()

@app.get('/')
def route():
    return "server functional"


@app.post('/login')
def home(req: LoginRequest):
    # db = db_emp_det()
    # rows = db.read(read_json_data)
    print(req)
    return "ok"
    # db_new = db()
    # rows = db_new.read({'info' : None, 'condition' : None})
    # print(json.dumps([str(i) for i in rows]))
    # return ''.join(str(i) for i in rows)


if __name__ == '__main__':
    run(app, port=5000)
    # home()