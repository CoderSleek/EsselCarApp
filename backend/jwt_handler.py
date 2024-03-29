from time import time
from jwt import encode, decode
from decouple import config

JWT_SECRET = config("secret")
JWT_ALGORITHM = config("algorithm")


def signJWT(userId : int, password: str):
    payload = {
        "userID" : userId,
        "password": password,
        "expiry" : time() + 900
    }
    token = encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return token


def decodeJWT(token : str):
    try:
        decoded_token = decode(token, JWT_SECRET, algorithms=JWT_ALGORITHM)
        return decoded_token if decoded_token['expiry'] >= time() else None

    except Exception as err:
        return None