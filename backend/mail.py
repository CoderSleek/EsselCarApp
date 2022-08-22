import smtplib
from email.message import EmailMessage
from enum import Enum

class email_manager:
    SENDER_EMAIL_ADDRESS = 'dnarula7jan@gmail.com'
    EMAIL_PASSWORD = 'rxujlhwzrhlhudqn'

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
    def email_handler(data_packet, function_enum):
        calling_function = function_enum
        body, subject = calling_function(data_packet)
        email_manager.send_email(data_packet['receiverEmail'], body, subject)
    

    @staticmethod
    def send_email(reciever_email: str, body: str, subject: str):
        # with smtplib.SMTP('smtp.gmail.com', 587) as smt:
        # with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smt:
        with smtplib.SMTP('localhost', 1025) as smt:
            try:
                # smt.ehlo()
                # smt.starttls()
                # smt.ehlo()

                # smt.login(SENDER_EMAIL_ADDRESS, EMAIL_PASSWORD)

                msg = EmailMessage()
                msg['Subject'] = subject
                msg['From'] = email_manager.SENDER_EMAIL_ADDRESS
                msg['To'] = reciever_email
                msg.set_content(body)
    #             msg.add_alternative("""\
    # <!DOCTYPE html>
    # <html>
    #     <body>
    #         <a href="www.google.com"><button type=button>click me</button></a>
    #     </body>
    # </html>
    # """, subtype='html')
                # msg = 'try's
                # smt.sendmail(SENDER_EMAIL_ADDRESS, reciever_email, msg)
                smt.send_message(msg)

                # print('done')
            except err:
                pass
                # print('failed', err)


    @staticmethod
    def new_request_mail(data: dict) -> str:
        body_string = email_manager.bodies['new_request'].format(data['mngName'], 
        data['empName'], data['travPurpose'])

        return body_string, email_manager.subjects['new_request_subject']
    

    @staticmethod
    def request_update_mail(data: dict) -> str:
        body_string = email_manager.bodies['request_update'].format(data['empName'], 
        data['travPurpose'], 'Accepted' if data['status'] else 'Rejected')

        if data['additionalComments']:
            body_string += email_manager.bodies['msg_comment'].format(data['additionalComments'])

        return body_string, email_manager.subjects['update_subject']


    @staticmethod
    def admin_request_mail(data: dict) -> str:
        body_string = email_manager.bodies['admin_update'].format(data['admName'], 
        data['empName'])
        
        return body_string, email_manager.subjects['new_request_subject']


    @staticmethod
    def admin_update_mail(data: dict) -> str:
        body_string = email_manager.bodies['request_completed'].format(data['empName'], 
        data['travPurpose'])

        return body_string, email_manager.subjects['update_subject']
            

class email_requests(Enum):
    NEW_BOOKING_REQUEST_TO_MANAGER = email_manager.new_request_mail
    BOOKING_REQUEST_UPDATE_TO_EMPLOYEE = email_manager.request_update_mail
    BOOKING_REQUEST_UPDATE_TO_ADMIN = email_manager.admin_request_mail
    ADMIN_UPDATE_EMAIL_TO_EMPLOYEE = email_manager.admin_update_mail

# send_email('devnarula0701@gmail.com')

# email_manager.email_handler({'mngName': 'Nev Darula', 'empName': 'Dev Narula', 'travPurpose':'bakchodi', 'receiverEmail':'nib@gib.com'}, email_requests.NEW_BOOKING_REQUEST_TO_MANAGER)
# email_manager.email_handler({'empName': 'Dev Narula', 'travPurpose':'bakchodi', 'status':True, 'additionalComments':'sexy', 'receiverEmail':'nib@gib.com'}, email_requests.BOOKING_REQUEST_UPDATE_TO_EMPLOYEE)
# email_manager.email_handler({'empName': 'Dev Narula', 'travPurpose':'bakchodi', 'status':False, 'additionalComments':None, 'receiverEmail':'nib@gib.com'}, email_requests.BOOKING_REQUEST_UPDATE_TO_EMPLOYEE)
# email_manager.email_handler({'admName': 'devar', 'empName':'dev narula', 'receiverEmail':'nib@gib.com'}, email_requests.BOOKING_REQUEST_UPDATE_TO_ADMIN)
# email_manager.email_handler({'empName': 'Dev Narula', 'travPurpose':'bakchodi', 'receiverEmail':'nib@gib.com'}, email_requests.ADMIN_UPDATE_EMAIL_TO_EMPLOYEE)

#python -m smtpd -c DebuggingServer -n localhost:1025