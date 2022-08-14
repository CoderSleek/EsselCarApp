import pyodbc

class db_handler:
    def __init__(self):
        self.db_conn = pyodbc.connect(
        "Driver={ODBC Driver 17 for SQL Server};"
        "Server=DEV\SQLEXPRESS;"
        "Database=VehicleAPP;"
        "Trusted_Connection=yes;"
        )

        self.read_template = '''\
SELECT {0} FROM booking_info WHERE {1}=?;'''


    def filled(self, id : int) -> bool:
        print(self.read_template.format('*', 'booking_id'))

db_handler().filled(1)