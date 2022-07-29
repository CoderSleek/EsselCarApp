from flask import Flask
from login_handler import db_handler as db

app = Flask(__name__)

@app.route('/')
def home():
    # return "api get called"
    db_new = db()
    rows = db_new.read({'info' : None, 'condition' : None})
    return [i for i in rows]

if __name__ == '__main__':
    # app.run()
    print(home())