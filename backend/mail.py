import smtplib
from email.message import EmailMessage

SENDER_EMAIL_ADDRESS = 'dnarula7jan@gmail.com'
EMAIL_PASSWORD = 'rxujlhwzrhlhudqn'

def send_email(reciever_email: str):
    # with smtplib.SMTP('smtp.gmail.com', 587) as smt:
    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smt:
    # with smtplib.SMTP('localhost', 1025) as smt:
        try:
            # smt.ehlo()
            # smt.starttls()
            # smt.ehlo()

            smt.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
            # body = 'body'

            msg = EmailMessage()
            msg['Subject'] = 'Update on Essel Mining Vehicle booking'
            msg['From'] = SENDER_EMAIL_ADDRESS
            msg['To'] = reciever_email
            msg.set_content(body)
            msg.add_alternative("""\
<html>
<body>
<button type="button">click me</button>
</body>
</html>\
""")

            # smt.sendmail(SENDER_EMAIL_ADDRESS, reciever_email, msg)
            smt.send_message(msg)

            print('done')
        except err:
            print('failed', err)
            


send_email('devnarula0701@gmail.com')