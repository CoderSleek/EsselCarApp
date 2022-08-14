import pyodbc
from pydantic import BaseModel


class VehicleInfoPacket(BaseModel):
    booking_id: int
    regNum: str
    model: str
    licenseExpDate: datetime.date
    insuranceExpDate: datetime.date
    pucExpDate: datetime.date
    driverName: str
    address: str
    licenseNum: str
    driverContact: int
    travAgentContact: int


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

        self.write_template = '''\
INSERT INTO vehicle_info values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'''


    def filled(self, id : int) -> bool:
        cursor = self.db_conn.cursor()
        item = cursor.execute(self.read_template.format('*', 'booking_id'), id).fetchone()
        return item != None

    
    def write_admin_packet(self, req: VehicleInfoPacket):
        cursor = self.db_handler.cursor()
        cursor.execute(self.write_template,
        req.booking_id,
        req.regNum,
        req.model,
        req.licenseExpDate,
        req.insuranceExpDate,
        req.pucExpDate,
        req.driverName,
        req.address,
        req.licenseNum,
        req.driverContact,
        req.travAgentContact)

        cursor.commit()

# print(db_handler().filled(1))