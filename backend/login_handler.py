import pyodbc

class db_handler:
    def __init__(self):
        self.db_conn = pyodbc.connect(
        "Driver={ODBC Driver 17 for SQL Server};"
        "Server=DEV\SQLEXPRESS;"
        "Database=VehicleAPP;"
        "Trusted_Connection=yes;"
        )
        self.read_query_template = """SELECT * FROM emp_details WHERE emp_id=?;"""
        self.write_query_template = 'INSERT INTO emp_details VALUES({0},{1},{2},{3},{4});'


    def _create_read_query(self, read_json_data: dict) -> str:
        new_query = self.read_query_template
        selection_stat, condition_stat = self.ALL, self.NONE

        if read_json_data['info'] != None:
            selection_stat = read_json_data['condition']

        if read_json_data['condition'] != None:
            condition_stat = read_json_data['condition']

        return new_query.format(selection_stat, condition_stat)


    def _create_write_query(self, write_json_data : dict) -> str:
        new_query = self.write_query_template
        x = self.db_conn.cursor().execute
        return new_query.format(write_json_data['name'],
        write_json_data['email'],
        write_json_data['loc'],
        write_json_data['mngid'],
        write_json_data['mngmail'],
        )


    def read(self, uid : int, columns = "emp_id") -> bool:
        cursor = self.db_conn.cursor()
        row = cursor.execute(self.read_query_template, uid).fetchone() #execute returns a generator for all the sql rows returned
        #fetchone returns the first sql row
        #in this case uid is unique so the database will always return one row
        return row


    def write(self, write_json_data : dict) -> bool:
        cursor = self.db_conn.cursor()
        cursor.execute(self._create_write_query(write_json_data))
        
        return True