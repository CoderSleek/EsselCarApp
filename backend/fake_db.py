from datetime import datetime

class Emp_item:
    def __init__(self, uid, pas, name, email, loc, position, mng_id):
        self.emp_id = uid
        self.emp_name = name
        self.password = pas
        self.emp_email = email
        self.emp_loc = loc
        self.position = position
        self.emp_mng_id = mng_id

    def __repr__(self):
        return f"{self.emp_id} {self.emp_name} {self.password} {self.emp_loc} {self.position} {self.emp_mng_id}"


class Veh_item:
    def __init__(self, bid, regnum, mod, insval, puc, nm, add, dcon, licexp, licnum, tcon, stdt=None, endt=None, intm=None, outtm=None):
        self.booking_id = bid
        self.veh_reg_num = regnum
        self.veh_model = mod
        self.insurance_validity = insval
        self.puc_expiry = puc
        self.driver_name = nm
        self.driver_address = add
        self.driver_contact = dcon
        self.license_expiry = licexp
        self.license_num = licnum
        self.trav_agent_contact = tcon
        self.start_dist = stdt
        self.end_dist = endt
        self.in_time = intm
        self.out_time = outtm

    def __repr__(self):
        return f"{self.booking_id} {self.veh_reg_num} {self.veh_model} {self.insurance_validity} {self.puc_expiry}\
 {self.driver_name} {self.driver_address} {self.driver_contact} {self.license_expiry} {self.license_num}\
 {self.trav_agent_contact} {self.start_dist} {self.end_dist} {self.in_time} {self.out_time}"


class Book_item:
    bid = 0
    def __init__(self, eid, trpur, expdist, pkdt, pkven, arrdt, mngid, addinf, rqdt):
        Book_item.bid += 1
        self.booking_id = Book_item.bid
        self.emp_id = eid
        self.trav_purpose = trpur
        self.expected_dist = expdist
        self.pickup_date_time = pkdt
        self.pickup_venue = pkven
        self.arrival_date_time = arrdt
        self.additional_info = addinf
        self.mng_id = mngid
        self.approval_status = None
        self.request_date_time = rqdt

    def __repr__(self):
        return f"{self.booking_id} {self.emp_id} {self.trav_purpose} {self.expected_dist} {self.pickup_date_time}\
 {self.pickup_venue} {self.arrival_date_time} {self.additional_info} {self.request_date_time} {self.approval_status}"

    
class db_emp_det:

    def __init__(self):
        self.items = []
        self.items.append(Emp_item(1, '123456', 'dev', 'dn@gmail.com', 'ranchi', 'employee', 2))
        self.items.append(Emp_item(2, '567890', 'test', 'test@gmail.com', 'ranchi', 'manager', 7))
        self.items.append(Emp_item(3, 'adminadmin', 'Administrator', 'dn@gmail.com', 'ranchi', 'admin', 2))
        for item in self.items:
            print(item)


    def read(self, uid):
        [var,] = [i for i in self.items if i.emp_id == uid]
        print(var)
        return var

    def get_mng_details(self, uid):
        [emp, ] = [i for i in self.items if i.emp_id == uid]
        [mng, ] = [i for i in self.items if i.emp_id == emp.emp_mng_id]
        return mng

    def get_admin_details(self, loc):
        adm_lst = [i for i in self.items if loc == i.emp_loc if i.position == 'admin']
        return adm_lst

    def get_all_admin(self):
        adm_lst = [i for i in self.items if i.position == 'admin']
        return adm_lst


class db_book_inf:

    def __init__(self):
        self.items = []
        dt1 = datetime.strptime('2022-08-31 03:00 PM', '%Y-%m-%d %I:%M %p')
        dt2 = datetime.strptime('2022-08-31 04:00 PM', '%Y-%m-%d %I:%M %p')
        rqdt = datetime.strptime('2022-10-31 17:00:00', '%Y-%m-%d %H:%M:%S')
        self.items.append(Book_item(1,'a', 2.82, dt1, 'a', dt2, 2, None, rqdt))
        self.items.append(Book_item(1,'b', 2.82, dt1, 'b', dt2, 2, None, rqdt))
        self.items.append(Book_item(1,'c', 2.82, dt1, 'c', dt2, 2, None, rqdt))
        
        for item in self.items:
            print(item)


    def write(self, req):
        adt = datetime.strptime(req.arrivalDateTime, '%Y-%m-%d %I:%M %p')
        pdt = datetime.strptime(req.pickupDateTime, '%Y-%m-%d %I:%M %p')
        rdt = datetime.strptime(req.reqDateTime, '%Y-%m-%d %H:%M:%S')
        item = Book_item(int(req.uid), req.travelPurpose, req.expectedDistance, pdt,
        req.pickupVenue, adt, req.managerID ,req.additionalInfo, rdt)

        self.items.append(item)



    def set_approval_status(self, bid, val):
        for item in self.items:
            if item.booking_id == bid:
                item.approval_status = val
                break


    def read(self, eid):
        x = []
        for item in self.items:
            if item.emp_id == eid:
                x.append(item)

        return x


    def get_rows(self):
        x = list(self.items)
        return iter(x)

    def get_row_by_booking_id(self, bid: int):
        [var, ] = [i for i in self.items if i.booking_id == bid]
        return var

    def get_approval_status(self, bid: int):
        for i in self.items:
            if i.booking_id == bid:
                return i.approval_status

    def get_mng_req(self, mng_id):
        return [i for i in self.items if i.mng_id == mng_id]

class db_veh_info:
    def __init__(self):
        self.items = []

    def filled(self, bid):
        ele = None
        for item in self.items:
            if item.booking_id == bid:
                ele = item
                break
        
        return ele != None

    def write_admin_packet(self, req):
        ele = Veh_item(req.bookingID,
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

        self.items.append(ele)
        print([i for i in self.items])

    def get_single_booking(self, bid):
        [x,] = [i for i in self.items if i.booking_id == bid]
        
        return x

    def get_time_data(self, bid):
        if not self.filled(bid):
            return False

        ele = None
        for i in self.items:
            if i.booking_id == bid:
                ele = i.start_dist
                break
        return ele == None 

    def write_time_data(self, packet):
        if not self.filled(packet.bookingID):
            return False

        for i in self.items:
            if i.booking_id == packet.bookingID:
                i.start_dist = packet.inDist
                i.end_dist = packet.outDist
                i.in_time = packet.inTime
                i.out_time = packet.outTime
                print(i)
                break

        return True

emp = db_emp_det()
booking = db_book_inf()
veh = db_veh_info()

def db_emp_det():
    return emp

def db_book_inf():
    return booking

def db_veh_info():
    return veh

# class a:
#     pass
# req = a()
# req.bookingID = 1
# req.vehRegNum = 'abcd'
# req.vehModel = 'hello'
# req.insuranceExpDate = 'a'
# req.pucExpDate = 'a'
# req.driverName = 'v'
# req.driverAddress = 'a'
# req.driverContact = 'd'
# req.licenseExpDate = 'z'
# req.licenseNum = 19823
# req.travAgentContact = 18228221
# print(veh.filled(1))
# veh.write_admin_packet(req)

# req2 = a()
# req2.inDist = 5
# req2.outDist = 5
# req2.in_time = 5
# req2.out_time = 5
# req2.bookingID = 1