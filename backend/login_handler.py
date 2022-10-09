import pyodbc

class db_handler:
    def __init__(self):
        self.db_conn = pyodbc.connect(
        "Driver={ODBC Driver 17 for SQL Server};"
        "Server=DEV\SQLEXPRESS;"
        "Database=VehicleAPP;"
        "Trusted_Connection=yes;"
        )

        self.read_query_template = "SELECT * FROM emp_details WHERE emp_id=?;"

        self.get_mng_template = ("SELECT * FROM emp_details WHERE emp_id="
        "(SELECT emp_mng_id FROM emp_details WHERE emp_id=?);")


    def read(self, uid : int) -> pyodbc.Row:
        cursor = self.db_conn.cursor()
        row = cursor.execute(self.read_query_template, uid).fetchone() #execute returns a generator for all the sql rows returned
        #fetchone returns the first sql row
        #in this case uid is unique so the database will always return one row
        return row

    
    def get_mng_details(self, uid : int) -> pyodbc.Row:
        cursor = self.db_conn.cursor()
        return cursor.execute(self.get_mng_template, uid).fetchone()
        #fetchone returns first row of db, .emp_mng_id returns the corresponding row value


    def get_admin_details(self, location: str) -> pyodbc.Row:
        cursor = self.db_conn.cursor()
        rows = cursor.execute("SELECT * FROM emp_details WHERE position LIKE '%admin%' AND emp_loc=?;", location)
        return rows


    def get_all_admin(self) -> pyodbc.Row:
        cursor = self.db_conn.cursor()
        rows = cursor.execute("SELECT * FROM emp_details WHERE position LIKE '%admin%'")
        return rows