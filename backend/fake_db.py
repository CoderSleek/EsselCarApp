class emp_item:
    def __init__(self, uid, pas, name, email, mng_email):
        self.emp_id = uid
        self.emp_name = name
        self.password = pas
        self.emp_email = email
        self.mng_email = mng_email

    def __repr__(self):
        return f"{self.emp_id} {self.emp_name} {self.password} {self.emp_email} {self.mng_email}"


class db_emp_det:
    
    def __init__(self):
        self.items = []
        self.items.append(emp_item(1, '123456', 'dev', 'dn@gmail.com', 'dn1@gm.com'))
        self.items.append(emp_item(2, '567890', 'test', 'test@gmail.com', 'test@gm.com'))
        for item in self.items:
            print(item)


    def read(self, uid):
        [var,] = [i for i in self.items if i.emp_id == uid]
        print(var)
        return var


class book_item:
    ids = 0

    def __init__(self, eid, pur, expdet, pkdt, pkven, arrdt, addinf, reqdt, appr=None):
        book_item.ids += 1
        self.bid = book_item.ids
        self.emp_id = eid
        self.trav_purpose = pur
        self.expected_dist = expdet
        self.pickup_date_time = pkdt
        self.pickup_venue = pkven
        self.arrival_date_time = arrdt
        self.additional_info = addinf
        self.reqDateTime = reqdt
        self.approval_status = appr

    def __repr__(self):
        return f"{self.bid} {self.emp_id} {self.trav_purpose} {self.expected_dist} {self.pickup_date_time}\
 {self.pickup_venue} {self.arrival_date_time} {self.additional_info} {self.reqDateTime} {self.approval_status}"


class db_book_inf:

    def __init__(self):
        self.items = []
        self.items.append(book_item(1,'a', 2.82, '2022-08-31 15:00:00', 'a', '2022-08-31 16:00:00'
        ,None, '2022-08-31 13:00:00'))
        self.items.append(book_item(1,'b', 2.82, '2022-08-31 15:00:00', 'b', '2022-08-31 16:00:00'
        ,None, '2022-08-31 13:00:00'))
        
        for item in self.items:
            print(item)


    def write(self, req):
        item = book_item(int(req.uid), req.travelPurpose, req.expectedDistance, req.pickupDateTime,
        req.pickupVenue, req.arrivalDateTime, req.additionalInfo, req.reqDateTime)

        self.items.append(item)
        for item in self.items:
            print(item)


    def set_approval_status(self, val, bid):
        for item in self.items:
            if item.bid == bid:
                item.approval_status = val

        for item in self.items:
            print(item)


    def read(self, eid):
        x = []
        for item in self.items:
            print(item)
            if item.emp_id == eid:
                x.append(item)

        return x


    def get_rows(self):
        return iter(self.items)

new1 = db_emp_det()
new2 = db_book_inf()

def db_emp_det():
    return new1

def db_book_inf():
    return new2