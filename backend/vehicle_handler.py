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
SELECT {0} FROM vehicle_info WHERE {1}=?;'''


    def filled(self, id : int) -> bool:
        cursor = self.db_conn.cursor()
        item = cursor.execute(self.read_template.format('*', 'booking_id'), id).fetchone()
        return item != None

    
    def write_admin_packet():
        pass

# print(db_handler().filled(1))