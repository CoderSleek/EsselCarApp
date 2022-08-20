const BACKEND_URL = 'http://127.0.0.1:5000/';
let page_number = 1
let data = [];

async function get_data(){
    data = [];
    data = [
        {"bookingID":3,"empID":1,"travelPurpose":"morning","expectedDist":42,"pickupDateTime":"01:03 AM 04-08-2022","pickupVenue":"morning","arrivalDateTime":"01:00 AM 04-08-2022","additionalInfo":null,"mngID":5,"isApproved":true,"requestDateTime":"10:33 AM 04-08-2022", "hasInfoFilled":false},
        {"bookingID":2,"empID":1,"travelPurpose":"timepass","expectedDist":20.8,"pickupDateTime":"03:59 PM 31-07-2022","pickupVenue":"kolkata","arrivalDateTime":"09:40 PM 31-07-2022","additionalInfo":null,"mngID":5,"isApproved":true,"requestDateTime":"04:00 PM 31-07-2022", "hasInfoFilled":true},
        {"bookingID":1,"empID":1,"travelPurpose":"business","expectedDist":7.5,"pickupDateTime":"10:00 AM 08-01-2022","pickupVenue":"office","arrivalDateTime":"11:00 AM 08-01-2022","additionalInfo":null,"mngID":5,"isApproved":null,"requestDateTime":"09:00 AM 08-01-2022", "hasInfoFilled":false}
    ]
    try{
        response = await fetch(BACKEND_URL + 'getbookingrequests',
        {method: 'POST',
        headers: {'Content-Type':'application/json'},
        body: JSON.stringify({"num":page_number}),
        });

        data = await response.json();
    } catch (err) {
        alert('Connectivity Issue');
    }

    if(data.length == 0 || data === undefined || data === null){
        window.document.querySelector('.content-box').innerHTML = `<span style="position:relative;
        left:50%;right:50%;top:50%;bottom:50%;">
        No Content</span>`;

        return;
    }
    data[0].isApproved = data[1].isApproved = true;
    data[1].hasInfoFilled = true;
    display_data();
}


function display_data(){

    const content_box = window.document.querySelector('.content-box');
    content_box.innerHTML = "";
    data.forEach((element, index) => {
        const approvalStatus = element.isApproved == null ? 'No Update' : (element.isApproved == true ? 'Approved' : 'Rejected')
        const itemContent = 
    `
        <div class="rowitems">
            <div class="eachitem"><span class="heading">Booking id: </span>${element.bookingID}</div>
            <div class="eachitem"><span class="heading">User id: </span>${element.empID}</div>
            <div class="eachitem"><span class="heading">Purpose: </span>${element.travelPurpose}</div>
        </div>
        <div class="rowitems">
            <div class="eachitem"><span class="heading">Expected Distance: </span>${element.expectedDist}</div>
            <div class="eachitem"><span class="heading">Pickup Venue: </span>${element.pickupVenue}</div>
            <div class="eachitem"><span class="heading">Approval Status: </span>${approvalStatus}</div>
        </div>
        <div class="rowitems">
            <div class="eachitem"><span class="heading">Pickup Date & Time: </span>${element.pickupDateTime}</div>
            <div class="eachitem"><span class="heading">Arrival Date & Time: </span>${element.arrivalDateTime}</div>
            <div class="eachitem"><span class="heading">Request Date & Time: </span>${element.requestDateTime}</div>
        </div>
        <div class="rowitems">
            <div class="eachitem"><span class="heading">Manager ID: </span>${element.mngID}</div>
            <div class="eachitem"><span class="heading">Additional Information: </span>${element.additionalInfo != null ? element.additionalInfo : 'None'}</div>
        </div>
    `

        const new_card = document.createElement('div');
        new_card.classList = 'content';
        new_card.id = 'card'+index;
        new_card.innerHTML += itemContent;

        if(element.isApproved === true){
            const new_div = document.createElement('div');
            new_div.className = 'rowitems';
            const new_btn = document.createElement('button');
            new_btn.type = 'button';
            new_btn.className = 'btn-class';
            new_div.appendChild(new_btn);

            if(element.hasInfoFilled === true){
                new_btn.textContent = 'View Vehicle Information';
            } else {
                new_btn.textContent = 'Set Vehicle Information';
            }
            new_card.appendChild(new_div);


            // new_card.innerHTML+=
            // `<div class="rowitems"><button type="button" class="btn-class">Set Vehicle Information</button></div>`
        }

        content_box.appendChild(new_card);
    });
}

function createNewInfoModal(){
    toggle_btns(true);
    booking_id = event.target.parentNode.parentNode.id;
    booking_id = data[booking_id.charAt(booking_id.length-1)].bookingID;

    const modal = document.getElementById('modal');
    const modalHtml = `
        <button type="button" class="close-btn" id="close-btn">X</button>
        <span style="font-family: 'Segoe UI';">Fill Information For booking id: ${booking_id}</span>
        <div class="eachrow">
            <span class="heading">Vehicle Registration Number: </span><input id="vehRegNum" type="text" maxlength=50>
            <span class="errorMsg hide"></span>
        </div>
        <div class="eachrow">
            <span class="heading">Vehicle Model: </span><input id="vehModel" maxlength=100>
            <div class="errorMsg hide"></div>
        </div>
        <div class="eachrow">
            <span class="heading">License Expiry Date: </span><input id="licenseExp" type="date">
            <div class="errorMsg hide"></div>
        </div>
        <div class="eachrow">
            <span class="heading">Insurance Expiry Date: </span><input id="insuranceExp" type="date">
            <div class="errorMsg hide"></div>
        </div>
        <div class="eachrow">
            <span class="heading">PUC Expiry Date: </span><input id="pucExp" type="date">
            <div class="errorMsg hide"></div>
        </div>
        <div class="eachrow">
            <span class="heading">Driver Name: </span><input id="driverName" maxlength=50>
            <div class="errorMsg hide"></div>
        </div>
        <div class="eachrow">
            <span class="heading">Driver Address: </span><input id="driverAddress" maxlength=200>
            <div class="errorMsg hide"></div>
        </div>
        <div class="eachrow">
            <span class="heading">License Number: </span><input id="licenseNumber" maxlength=50>
            <div class="errorMsg hide"></div>
        </div>
        <div class="eachrow">
            <span class="heading">Driver Contact Information: </span><input id="driverContact" type="tel">
            <div class="errorMsg hide"></div>
        </div>
        <div class="eachrow">
            <span class="heading">Travel Agent Contact**: </span><input id="travContact" type="tel">
            <div class="errorMsg hide"></div>
        </div>
        <button type="button" id="submit" class="btn-class" style="left:50%; transform: translate(-50%); margin-top: 18px;">Submit</button>
        `
        modal.innerHTML = modalHtml;
        togglemodal();
        modal.querySelector('.close-btn').addEventListener('click', ()=>{togglemodal(), toggle_btns(false)});
        modal.querySelector('#submit').addEventListener('click', sendInfo);
}

async function sendInfo(){
        const idString = event.target.parentNode.children[1].textContent;
        const idNumber = idString.match(new RegExp("\\d+$"))[0];

        const packet = {
        "bookingID": idNumber,
        "vehRegNum": document.getElementById("vehRegNum").value,
        "vehModel": document.getElementById("vehModel").value,
        "licenseExpDate": document.getElementById("licenseExp").value,
        "insuranceExpDate": document.getElementById("insuranceExp").value,
        "pucExpDate": document.getElementById("pucExp").value,
        "driverName": document.getElementById("driverName").value,
        "driverAddress": document.getElementById("driverAddress").value,
        "driverContact": document.getElementById("driverContact").value,
        "licenseNum": document.getElementById("licenseNumber").value,
        "travAgentContact": document.getElementById("travContact").value
    }

    if(!validatePacket(packet)){
        return;
    }

    if(packet.travAgentContact == ""){
        packet.travAgentContact = null;
    }
    const res = await fetch(BACKEND_URL+'newvehicleinfo', {method:'POST',
    headers:{'Content-Type':'application/json'},
    body: JSON.stringify(packet)});

    
    if(res.status == 200){
        console.log('inside changer');
        const x = data.findIndex((element) => 
        {return element.bookingID === parseInt(idNumber)})
        data[x].hasInfoFilled = true;
        const view_btn = document.querySelectorAll('.content')[x].querySelector('.btn-class');
        view_btn.textContent = 'View Vehicle Information';
        view_btn.removeEventListener('click', createNewInfoModal, true);
        view_btn.addEventListener('click', createViewInfoModal);
        toggle_btns(false);
        togglemodal();
    } else {
        alert('error');
    }
}

function validatePacket(packet){
    let bool_return = {'item':true};
    resetInputErrorMsg();
    let error_element;
    const alpha_only = new RegExp("^[A-Za-z]+[A-Za-z ]*$");
    const alpha_num = new RegExp("^[A-Za-z0-9]+[A-Za-z0-9 ]*$");
    // const vehicle_number = new RegExp("^[A-Z]{2}[ -]*[0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$");
    // const vehicle_number = new RegExp('^[A-Za-z]{2}[ -]?[0-9]{1,2}[A-Za-z]{1}[ -]?[0-9]{4}$');
    const special = new RegExp("[A-Z]{2}[ 0-9A-Z-]{3,}[0-9]{4}$");
    const number_only = new RegExp('^[0-9]{10}$');

    if(!special.test(packet.vehRegNum)){
        error_element = document.getElementById('vehRegNum').nextElementSibling;
        set_error_msg(error_element, bool_return, 'Enter a Valid Vehicle Plate Number');
    }
    if(!alpha_only.test(packet.vehModel)){
        error_element = document.getElementById('vehModel').nextElementSibling;
        set_error_msg(error_element, bool_return, 'Only letter and space allowed');
    }
    if(!alpha_only.test(packet.driverName)){
        error_element = document.getElementById('driverName').nextElementSibling;
        set_error_msg(error_element, bool_return, 'Only letter and space allowed');
    }
    if(!alpha_num.test(packet.driverAddress)){
        error_element = document.getElementById('driverAddress').nextElementSibling;
        set_error_msg(error_element, bool_return, 'Only letter, digit and space allowed');
    }
    if(!RegExp('^[A-Za-z]{2}[ -]*[0-9]{2}[ -]*[0-9]+$').test(packet.licenseNum)){
        error_element = document.getElementById('licenseNumber').nextElementSibling;
        set_error_msg(error_element, bool_return, 'Enter valid license number');
    }
    if(!number_only.test(packet.driverContact)){
        error_element = document.getElementById('driverContact').nextElementSibling;
        set_error_msg(error_element, bool_return, 'Enter valid Phone number');
    }
    if(!RegExp('^(?:\\d{10}|)$').test(packet.travAgentContact)){
        error_element = document.getElementById('travContact').nextElementSibling;
        set_error_msg(error_element, bool_return, 'Enter valid Phone number');
    }

    if(packet.vehRegNum.length == 0){
        set_error_msg(document.getElementById('vehRegNum').nextElementSibling, bool_return);
    }
    if(packet.vehModel.length == 0){
        set_error_msg(document.getElementById('vehModel').nextElementSibling, bool_return);
    }
    if(packet.licenseExpDate.length == 0){
        set_error_msg(document.getElementById('licenseExp').nextElementSibling, bool_return);
    }
    if(packet.insuranceExpDate.length == 0){
        set_error_msg(document.getElementById('insuranceExp').nextElementSibling, bool_return);
    }
    if(packet.pucExpDate.length == 0){
        set_error_msg(document.getElementById('pucExp').nextElementSibling, bool_return);
    }
    if(packet.driverName.length == 0){
        set_error_msg(document.getElementById('driverName').nextElementSibling, bool_return);
    }
    if(packet.driverAddress.length == 0){
        set_error_msg(document.getElementById('driverAddress').nextElementSibling, bool_return);
    }
    if(packet.licenseNum.length == 0){
        set_error_msg(document.getElementById('licenseNumber').nextElementSibling, bool_return);
    }
    if(packet.driverContact.length == 0){
        set_error_msg(document.getElementById('driverContact').nextElementSibling, bool_return);
    }

    return bool_return.item;
}

function set_error_msg(error_element, bool_return, error_msg = 'Cannot be empty'){
    error_element.textContent = error_msg;
    error_element.classList.remove('hide');
    bool_return.item = false;
}

function togglemodal(){
    document.getElementById('modal').classList.toggle('hide');
    document.body.classList.toggle('hide-body');
}

function toggle_btns(status){
    const btn_list = Array.from(document.getElementsByTagName('button'));
    btn_list.forEach((element)=>{
        element.disabled = status;
    })
}

async function createViewInfoModal(){
    toggle_btns(true);
    let booking_id = event.target.parentNode.parentNode.id;
    booking_id = data[booking_id.charAt(booking_id.length-1)].bookingID;

    let element_data = await fetch(BACKEND_URL+'getvehicleinfo',{
        method:'POST', headers:{'Content-Type':'application/json'},
        body:JSON.stringify({'bookingID':booking_id})
    });  
    element_data = await element_data.json()

    const modal = document.getElementById('modal');
    const modalHtml = `
        <button type="button" class="close-btn" id="close-btn">X</button>
        <span style="font-family: 'Segoe UI';">Viewing Information For booking id: ${booking_id}</span>
        <div class="eachrow">
            <span class="heading">Vehicle Registration Number: </span><input id="vehRegNum" disabled value="${element_data.vehRegNum}">
        </div>
        <div class="eachrow">
            <span class="heading">Vehicle Model: </span><input id="vehModel" disabled value="${element_data.vehModel}">
        </div>
        <div class="eachrow">
            <span class="heading">License Expiry Date: </span><input id="licenseExp" disabled value="${element_data.licenseExpDate}">
        </div>
        <div class="eachrow">
            <span class="heading">Insurance Expiry Date: </span><input id="insuranceExp" disabled value="${element_data.insuranceExpDate}">
        </div>
        <div class="eachrow">
            <span class="heading">PUC Expiry Date: </span><input id="pucExp" disabled value="${element_data.pucExpDate}">
        </div>
        <div class="eachrow">
            <span class="heading">Driver Name: </span><input id="driverName" disabled value="${element_data.driverName}">
        </div>
        <div class="eachrow">
            <span class="heading">Driver Address: </span><input id="driverAddress" disabled value="${element_data.driverAddress}">
        </div>
        <div class="eachrow">
            <span class="heading">License Number: </span><input id="licenseNumber" disabled value="${element_data.licenseNum}">
        </div>
        <div class="eachrow">
            <span class="heading">Driver Contact Information: </span><input id="driverContact" type="tel" disabled value="${element_data.driverContact}">
        </div>
        <div class="eachrow">
            <span class="heading">Travel Agent Contact: </span><input id="travContact" type="tel" disabled value="${element_data.travAgentContact ?? 'Not Provided'}">
        </div>
        <div class="eachrow">
            <span class="heading">In Distance: </span><input disabled value="${element_data.inDist ?? 'Not Updated'}">
        </div>
        <div class="eachrow">
            <span class="heading">Out Distance: </span><input disabled value="${element_data.outDist ?? 'Not Updated'}">
        </div>
        <div class="eachrow">
            <span class="heading">In Time: </span><input disabled value="${element_data.inTime ?? 'Not Updated'}">
        </div>
        <div class="eachrow" style="padding-top:15px !important;">
            <span class="heading">Out Time: </span><input disabled value="${element_data.outTime ?? 'Not Updated'}">
        </div>
        `;

        modal.innerHTML = modalHtml;
        togglemodal();
        modal.querySelector('.close-btn').addEventListener('click', ()=>{togglemodal(), toggle_btns(false)});
}

function assigneventlistener(){
    // btn = document.querySelectorAll('.btn-class');
    const content_view = document.querySelectorAll('.content');
    content_view.forEach((element)=>{
        const content_view_id = data[element.id.charAt(element.id.length-1)];
        if(content_view_id.isApproved === true){
            if(content_view_id.hasInfoFilled === true){
                element.lastElementChild.firstChild.addEventListener('click', createViewInfoModal);
            } else {
                element.lastElementChild.firstChild.addEventListener('click', createNewInfoModal, true);
            }
        }
    })
    // btn.forEach((element)=>{
    //     if(element.hasInfoFilled === true){
    //         element.addEventListener('click', createViewInfoModal);
    //     } else {
    //         console.log(element);
    //         element.addEventListener('click', createNewInfoModal);
    //     }
    // })
}

function assignPageNumber(){
    const btn_div = document.querySelector('#pg_num');
    btn_div.textContent = ` Page Number ${page_number}`;
}

function prevPage(){
    if(page_number <= 1) return;
    page_number -=1;
    initializePage();
}

function nextPage(){
    if(data.length == 0) return;
    page_number += 1;
    initializePage();
}

function initializePage(){
    get_data().then(assigneventlistener);
    assignPageNumber();
}

function resetInputErrorMsg(){
    const item_list = document.querySelectorAll('.eachrow');

    // if(item_list[0].lastElementChild.classList.contains('hide')) return;

    item_list.forEach((element)=>{
        element.lastElementChild.classList.add('hide');
    })
}

initializePage();
document.getElementById('prev_page').addEventListener('click', prevPage);
document.getElementById('next_page').addEventListener('click', nextPage);
