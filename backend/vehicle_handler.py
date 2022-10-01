import pyodbc
from pydantic import BaseModel
from datetime import date

class VehicleInfoPacket(BaseModel):
    bookingID: int
    vehRegNum: str
    model: str
    licenseExpDate: date
    insuranceExpDate: date
    pucExpDate: date
    driverName: str
    driverAddress: str
    driverContact: int
    licenseNum: str
    travAgentContact: int or None


class db_handler:
    def __init__(self):
        self.db_conn = pyodbc.connect(
        "Driver={ODBC Driver 17 for SQL Server};"
        "Server=DEV\SQLEXPRESS;"
        "Database=VehicleAPP;"
        "Trusted_Connection=yes;"
        )

        self.read_template = '''\
SELECT {0} FROM vehicle_info WHERE booking_id=?;'''

        self.write_template = '''\
INSERT INTO vehicle_info (booking_id, veh_reg_num, veh_model, insurance_validity, puc_expiry,\
 driver_name, driver_address, driver_contact, license_expiry, license_num, trav_agent_contact)\
 values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);'''

#         self.read_template = '''\
# SELECT * FROM vehicle_info WHERE booking_id=?'''


    def filled(self, booking_id : int) -> bool:
        cursor = self.db_conn.cursor()
        item = cursor.execute(self.read_template.format('booking_id'), booking_id).fetchone()
        return item != None


    def write_admin_packet(self, req: VehicleInfoPacket) -> None:
        cursor = self.db_conn.cursor()

        cursor.execute(self.write_template,
        req.bookingID,
        req.vehRegNum,
        req.vehModel,
        req.insuranceExpDate,
        req.pucExpDate,
        req.driverName,
        req.driverAddress,
        req.driverContact,
        req.licenseExpDate,
        req.licenseNum,
        req.travAgentContact)

        cursor.commit()


    def get_single_booking(self, bookingID: int) -> pyodbc.Row:
        cursor = self.db_conn.cursor()
        return cursor.execute(self.read_template, bookingID).fetchone()

    
    def get_time_data(self, booking_id: int) -> bool:
        if not self.filled(booking_id):
            return False

        cursor = self.db_conn.cursor()
        time_data = cursor.execute(self.read_template.format('start_dist'), booking_id).fetchone()

        # return time_data if time_data[0] != None else None
        return time_data == None