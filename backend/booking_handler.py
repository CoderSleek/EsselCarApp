import pyodbc
from pydantic import BaseModel

class NewBooking(BaseModel):
    uid: int
    travelPurpose: str
    expectedDistance: float
    pickUpTimeDate: str
    pickupVenue: str
    arrivalTimeDate: str
    additionalInfo: (str | None)
    reqDateTime: str
    managerID: int


class db_handler:
    def __init__(self):
        self.db_conn = pyodbc.connect(
        "Driver={ODBC Driver 17 for SQL Server};"
        "Server=DEV\SQLEXPRESS;"
        "Database=VehicleAPP;"
        "Trusted_Connection=yes;"
        )

        self.write_template = ("INSERT INTO "
            "booking_info(booking_id, emp_id, trav_purpose, expected_dist, pickup_date_time, "
            "pickup_venue, arrival_date_time, additional_info, mng_id, request_date_time) "
            "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?);")

        self.read_join_template = ("SELECT booking_id, booking_info.emp_id, trav_purpose, expected_dist, "
            "pickup_date_time, pickup_venue, arrival_date_time, "
            "additional_info, approval_status FROM booking_info, emp_details "
            "WHERE booking_info.emp_id = emp_details.emp_id AND emp_details.emp_mng_id = ? "
            "ORDER BY request_date_time DESC;")


    def get_id(self) -> int:
        cursor = self.db_conn.cursor()
        return 1 + (cursor.execute('SELECT booking_id FROM booking_info ORDER BY booking_id DESC;').fetchval() or 0)
        #retrieves only one value, 1st column of first row
        #if the first value is null i.e. no row in table then executes or statemens and adds 0 to 1


    def write(self, request: NewBooking) -> bool:
        cursor = self.db_conn.cursor()
        cursor.execute(self.write_template, self.get_id(), request.uid, request.travelPurpose,
        request.expectedDistance, request.pickupDateTime, request.pickupVenue,
        request.arrivalDateTime, request.additionalInfo, request.managerID,
        request.reqDateTime)
        
        cursor.commit()
        return True


    def set_approval_status(self, bid : int, value: bool) -> bool:
        cursor = self.db_conn.cursor()
        cursor.execute('UPDATE booking_info SET approval_status=? WHERE booking_id=?;', value, bid)

        cursor.commit()
        return True


    def read(self, uid: int, rowcount: int = 5) -> pyodbc.Row:
        cursor = self.db_conn.cursor()
        return cursor.execute("SELECT * FROM booking_info WHERE emp_id=? ORDER BY request_date_time DESC;", uid).fetchmany(rowcount)


    def get_rows(self) -> pyodbc.Row:
        cursor = self.db_conn.cursor()
        return cursor.execute("SELECT * FROM booking_info ORDER BY request_date_time DESC;")


    def get_row_by_booking_id(self, bid: int) -> pyodbc.Row:
        cursor = self.db_conn.cursor()
        return cursor.execute("SELECT * FROM booking_info WHERE booking_id=?", bid).fetchone()


    def get_approval_status(self, bid: int) -> bool | None:
        isApproved = self.get_row_by_booking_id(bid).approval_status
        return isApproved

    
    def get_mng_req(self, mng_id: int) -> pyodbc.Row:
        cursor = self.db_conn.cursor()
        rows = cursor.execute(self.read_join_template, mng_id).fetchmany(5)
        return rows