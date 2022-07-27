import pyodbc


class db_handler:
    def __init__(self):
        self.db_conn = pyodbc.connect(
        "Driver={ODBC Driver 17 for SQL Server};"
        "Server=DEV\SQLEXPRESS;"
        "Database=VehicleAPP;"
        "Trusted_Connection=yes;"
        )
        self.read_query_template = 'SELECT {0} FROM emp_details WHERE {1};'
        self.write_query_template = 'INSERT INTO emp_details VALUES({0},{1},{2},{3},{4});'
        self.ALL = '*'
        self.NONE =  '1=1'


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

    def read(self, read_json_data : dict) -> bool:
        cursor = self.db_conn.cursor()
        rows = cursor.execute(self._create_read_query(read_json_data))
        for row in rows:
            print(row)
        return True


    def write(self, write_json_data : dict) -> bool:
        cursor = self.db_conn.cursor()
        cursor.execute(self._create_write_query(write_json_data))
        
        return True



def main():
    new_connection = db_handler()
    example_json = {
        'info': None,
        'condition': None,
    }
    example_json2 = {
        'name' : "'x'",
        'email' : "'y@z.com'",
        'loc': "'rkl'",
        'mngid': "'11'",
        'mngmail': "'11@z.com'",
    }
    new_connection.write(example_json2)
    new_connection.read(example_json)

if __name__ == '__main__':
    main()