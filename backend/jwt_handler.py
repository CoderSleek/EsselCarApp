import time
import jwt
from decouple import config

JWT_SECRET = config("secret")
JWT_ALGORITHM = config("algorithm")

#returns generated tokens
# def token_response(token : str):
#     return {
#         "access token" : token 
#     }


def signJWT(userId : int, password: str):
    payload = {
        "userID" : userId,
        "password": password,
        "expiry" : time.time() + 900
    }
    token = jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return token


def decodeJWT(token : str):
    try:
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=JWT_ALGORITHM)
        return decoded_token if decoded_token['expiry'] >= time.time() else None
    except Exception as err:
        return None