class Item:
    def __init__(self, ids, pas):
        self.uid = ids
        self.password = pas

    def __repr__(self):
        return "(uid: {0}, password: {1})".format(self.uid, self.password)
            

class emp_item:
    def __init__(self, uid, name, email, mng_email):
        self.uid = uid
        self.name = name
        self.email = email
        self.mng_email = mng_email

    def __repr__(self):
        return f"(uid: {self.uid}, password: {self.name}, email: {self.email}, mng: {self.mng_email})"


class db_emp_det:
    
    def __init__(self):
        self.items = []
        self.items.append(Item(1, '123456'))
        self.items.append(Item(2, '567890'))
        print([i for i in self.items])

        self.items_det = []
        self.items_det.append(emp_item(1, 'dev', 'dn@gmail.com', 'dn1@gm.com'))
        self.items_det.append(emp_item(2, 'test', 'test@gmail.com', 'test@gm.com'))


    def read(self, uid):
        [var,] = [i for i in self.items_det if i.uid == uid]
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
        self.items.append(book_item(1,'a', 2.82, '2022-08-31 15:00:00', 'a', '2022-08-31 16:00:00'
        ,None, '2022-08-31 13:00:00'))
        
        for item in self.items:
            print(item)

new = db_emp_det()
new = db_book_inf()
# new.read(1)