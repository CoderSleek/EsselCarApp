import smtplib
from email.message import EmailMessage
from enum import Enum

class Email_manager:
    SENDER_EMAIL_ADDRESS = ''
    EMAIL_PASSWORD = ''

    bodies = {
    'new_request': "Dear {0},\n"
        "There is a new vehicle requisition request for approval from your employee {1} with the purpose of {2}, "
        "Please check Essel Mining vehicle booking app to review the request.",

    'request_update': "Dear {0},\n"
        "Your Essel booking vehicle requisition request with purpose {1} has been {2} by your manager.",

    'msg_comment': "\n\nWith the additional comment of {}.",

    'admin_update': "Dear {0},\n"
        "A new request by {1} for Essel mining vehicle booking has been approved by their respective manager, "
        "Please login to Essel Mining vehicle booking admin panel to fill the required details of the request.",

    'request_completed': "Dear {0},\n"
        "Your Essel mining vehicle booking request {1} has been successfully verified by the admin and now you can "
        "initiate the ride as per the pickup Time set by you from Essel Mining Vehicle Booking App."
    }

    subjects = {
        'new_request_subject': "New Essel Mining vehicle request",
        'update_subject': "Update on Essel Mining Vehicle booking"
    }


    @staticmethod
    def email_handler(data_packet: dict, function_enum: callable) -> None:
        calling_function = function_enum
        body, subject = calling_function(data_packet)
        Email_manager.send_email(data_packet['receiverEmail'], body, subject)


    @staticmethod
    def send_email(reciever_email: str, body: str, subject: str) -> None:
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smt:
            try:
                smt.login(Email_manager.SENDER_EMAIL_ADDRESS, Email_manager.EMAIL_PASSWORD)

                msg = EmailMessage()
                msg['Subject'] = subject
                msg['From'] = Email_manager.SENDER_EMAIL_ADDRESS
                msg['To'] = reciever_email
                msg.set_content(body)

                smt.send_message(msg)
            except Exception as e:
                pass


    @staticmethod
    def new_request_mail(data: dict) -> tuple:
        body_string = Email_manager.bodies['new_request'].format(data['mngName'], 
        data['empName'], data['travPurpose'])

        return body_string, Email_manager.subjects['new_request_subject']
    

    @staticmethod
    def request_update_mail(data: dict) -> tuple:
        body_string = Email_manager.bodies['request_update'].format(data['empName'], 
        data['travPurpose'], 'Accepted' if data['status'] else 'Rejected')

        if data['additionalComments']:
            body_string += Email_manager.bodies['msg_comment'].format(data['additionalComments'])

        return body_string, Email_manager.subjects['update_subject']


    @staticmethod
    def admin_request_mail(data: dict) -> tuple:
        body_string = Email_manager.bodies['admin_update'].format(data['admName'], 
        data['empName'])
        
        return body_string, Email_manager.subjects['new_request_subject']


    @staticmethod
    def admin_update_mail(data: dict) -> tuple:
        body_string = Email_manager.bodies['request_completed'].format(data['empName'], 
        data['travPurpose'])

        return body_string, Email_manager.subjects['update_subject']
            

class Email_requests(Enum):
    NEW_BOOKING_REQUEST_TO_MANAGER = Email_manager.new_request_mail
    BOOKING_REQUEST_UPDATE_TO_EMPLOYEE = Email_manager.request_update_mail
    BOOKING_REQUEST_UPDATE_TO_ADMIN = Email_manager.admin_request_mail
    ADMIN_UPDATE_EMAIL_TO_EMPLOYEE = Email_manager.admin_update_mail