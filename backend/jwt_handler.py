import time
import jwt
from decouple import config

JWT_SECRET = config("secret")
JWT_ALGORITHM = config("algorithm")

#returns generated tokens
def token_response(token : str):
    return {
        "access token" : token 
    }


def signJWT(userId : str, password: str):
    payload = {
        "userName" : userId,
        "password": password,
        "expiry" : time.time() + 60

    }
    token = jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return token


def decodeJWT(token : str):
    try:
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=JWT_ALGORITHM)
        return decoded_token if decoded_token['expiry'] >= time.time() else None
    except:
        return None