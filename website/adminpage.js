const BACKEND_URL = 'http://127.0.0.1:5000/';
let PAGE_NUMBER = 1; /*10 items per page, used to get next 10/prev 10 items from server*/
let DATA = [];

/** fetch json data from api, gets an array */
async function get_data(){
    DATA = []; /* reset everytime data is fetched from server */
    try{
        let response = await fetch(BACKEND_URL + 'getbookingrequests',
        {
            method: 'POST',
            headers: {
                'Content-Type':'application/json',
                'Authorization': sessionStorage.getItem('accessToken') ?? '' /*checks for jwt, if not exists send ''*/
            },
            body: JSON.stringify({"num": PAGE_NUMBER}),
        });

        if(response.status === 401){ /*invalid jwt response code*/
            window.location.replace('/unauthorized');
        }

        DATA = await response.json(); /* json array */
    } catch (err) {
        alert('Connectivity Issue');
        return;
    }

    if(DATA.length == 0 || DATA === undefined || DATA === null){
        window.document.querySelector('.content-box').innerHTML = `<span style="position:relative;
        left:50%;right:50%;top:50%;bottom:50%;">
        No Content</span>`;
        return; /* dont display data if empty */
    }
    display_data();
}

/** load data fetched from api to display in content-box div */
function display_data(){
    const content_box = window.document.querySelector('.content-box');
    content_box.innerHTML = ""; /* reset content box having dom elements */

    DATA.forEach((element, index) => {
        /* element is an object {} */
        const approvalStatus = element.isApproved == null ? 'No Update' : (element.isApproved == true ? 'Approved' : 'Rejected');

        /** each dom element content to append inside content box */
        const itemContent = `
        <div class="rowitems">
            <div class="eachitem"><span class="heading">Booking id: </span>${element.bookingID}</div>
            <div class="eachitem"><span class="heading">Employee Name: </span>${element.empName}</div>
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
    `;

        
        const new_card = document.createElement('div'); /** new dom element */
        new_card.classList = 'content'; /** set class for dom ele, could also use classList.add() */
        new_card.id = 'card' + index; /* id like card0 card1 etc based on card position */
        new_card.innerHTML += itemContent;

        if(element.isApproved === true){
            /* create button based on a certain property */
            const new_div = document.createElement('div');
            /* created parent div to center the button */
            new_div.className = 'rowitems';
            const new_btn = document.createElement('button');
            new_btn.type = 'button';
            new_btn.className = 'btn-class';
            new_div.appendChild(new_btn);

            if(element.hasInfoFilled === true){
                /* create different button based on bool property */
                new_btn.textContent = 'View Vehicle Information';
                new_btn.addEventListener('click', createViewInfoModal);
            } else {
                new_btn.textContent = 'Set Vehicle Information';
                new_btn.addEventListener('click', createNewInfoModal, true);
                /* true flag allows to remove event listener later */
            }
            new_card.appendChild(new_div);
        }

        content_box.appendChild(new_card);
    });
}

/** creates modal for content elements whose data does not exist in db */
function createNewInfoModal(){
    toggle_btns(true); /** disables buttons while modal is open */
    
    const content_ele = event.target.parentElement.parentElement; /** get parent div 'content' */
    /**get position of content element in content-box element */
    const index_of_content_ele = Array.from(document.querySelectorAll('.content')).indexOf(content_ele);

    const modal = document.getElementById('modal');
    /* content inside modal, created new everytime */
    const modalHtml = `
        <button type="button" class="close-btn" id="close-btn">X</button>
        <span style="font-family: 'Segoe UI';">Fill Information For booking id: ${DATA[index_of_content_ele].bookingID}</span>
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
        `;

    modal.innerHTML = modalHtml;
    /*turns modal on or off*/
    togglemodal();
    /**toggle btns enables/disables buttons when modal is open */
    /* close-btn closes the modal and enables all buttons on page */
    modal.querySelector('.close-btn').addEventListener('click', ()=>{togglemodal(); toggle_btns(false)});
    /**sends newly enetered data to api */
    modal.querySelector('#submit').addEventListener('click', () => sendInfo(DATA[index_of_content_ele].bookingID));
}

/**send new item data enterd in modal to the server */
async function sendInfo(bookingID){

    const packet = {
    "bookingID": bookingID,
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

    /**validates data entered */
    if(!validatePacket(packet)){
        return;
    }

    if(packet.travAgentContact == ""){
        packet.travAgentContact = null;
    }

    try{
        const res = await fetch(BACKEND_URL+'newvehicleinfo',
        {
            method:'POST',
            headers:{
                'Content-Type': 'application/json',
                'Authorization': sessionStorage.getItem('accessToken') ?? ''
            },
            body: JSON.stringify(packet)
        });

        if(res.status === 401){ /* expired jwt */
            window.location.replace('/unauthorized');
        }

        /*index of updated object in DATA */
        const updated_object_index = DATA.findIndex((element) => 
        {
            return element.bookingID === parseInt(bookingID);
        });

        /** updating dom element of DATA object */
        DATA[updated_object_index].hasInfoFilled = true;
        const view_btn = document.querySelectorAll('.content')[updated_object_index].querySelector('.btn-class');
        view_btn.textContent = 'View Vehicle Information';
        /*switch event listener of content ele button */
        view_btn.removeEventListener('click', createNewInfoModal, true);
        view_btn.addEventListener('click', createViewInfoModal);
        /* toggle disabled buttons and hide modal */
        toggle_btns(false);
        togglemodal();
    }
    catch (err){
        alert('Some error occured');
    }
}

/* validates data entered in modal, client side validation */
function validatePacket(packet){
    let bool_return = {'item': true}; /*using object to obtain pass by reference functionality*/
    resetInputErrorMsg(); /* remove red error messages from modal */

    let error_element;
    /*regex for validation data in modal */
    const alpha_only = new RegExp("^[A-Za-z]+[A-Za-z ]*$");
    const alpha_num = new RegExp("^[A-Za-z0-9]+[A-Za-z0-9 ]*$");
    const special = new RegExp("[A-Z]{2}[ 0-9A-Z-]{3,}[0-9]{4}$");
    const number_only = new RegExp('^[0-9]{10}$');

    /* if regex validation is false then call function with error msg, and error element text, also sets bool_return */
    if(!special.test(packet.vehRegNum)){
        /* next element sibling is a togglable error message next to input field in modal */
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

    /* different check for data validation and data empty check since different error msg need be displayed*/
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

    /*returns validation outcome*/
    return bool_return.item;
}

/* unhides error message modal, sets text to error_msg and sets validation to false*/
function set_error_msg(error_element, bool_return, error_msg = 'Cannot be empty'){
    error_element.textContent = error_msg;
    error_element.classList.remove('hide');
    bool_return.item = false;
}

/* hide modal after displaying newInfoModal or viewInfoModal */
/** tried to blur the body a little when modal is visible, didnt work */
function togglemodal(){
    document.getElementById('modal').classList.toggle('hide');
    document.body.classList.toggle('hide-body');
}

/* enables and disables button based on modal visibility, accepts bool */
/**toggles both page change and set/view vehicle info button */
/**as a side ffect also changes close modal and submit modal button but they are created new everytiem so doesnt matter */
function toggle_btns(status){
    const btn_list = Array.from(document.getElementsByTagName('button'));
    btn_list.forEach((element)=>{
        element.disabled = status;
    })
}

/** create modal displaying already existing data fetched from api */
async function createViewInfoModal(){
    toggle_btns(true);
    /* gets parent content element for the called view/set vehicle info button */
    const parent_content_ele = event.target.parentElement.parentElement;
    /*finds index of said content in content-box parent*/
    const index_of_content_ele = Array.from(document.querySelectorAll('.content')).indexOf(parent_content_ele);
    let element_data;

    try{
        let res = await fetch(BACKEND_URL+'getvehicleinfo',
        {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': sessionStorage.getItem('accessToken') ?? ''
            },
            body: JSON.stringify({'bookingID': DATA[index_of_content_ele].bookingID}) /*just getting the booking id*/
        });

        if(res.status === 401){ /*invalid jwt*/
            window.location.replace('/unauthorized');
        }

        /*contains data to display in modal, sent by api*/
        element_data = await res.json();
    } catch (err) {
        alert('Some error occured');
        toggle_btns(false);
        return;
    }

    const modal = document.getElementById('modal');
    /* modal html content, recreated everytime*/
    const modalHtml = `
        <button type="button" class="close-btn" id="close-btn">X</button>
        <span style="font-family: 'Segoe UI';">Viewing Information For booking id: ${DATA[index_of_content_ele].bookingID}</span>
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
    /* close-btn closes the modal and enables all buttons on page */
    modal.querySelector('.close-btn').addEventListener('click', ()=>{togglemodal(); toggle_btns(false)});
}

/* assigns page number after every fetch data request from api */
function assignPageNumber(){
    const btn_div = document.querySelector('#pg_num');
    btn_div.textContent = ` Page Number ${PAGE_NUMBER}`;
}

/* load previous 10 data from api logic*/
function prevPage(){
    if(PAGE_NUMBER <= 1) return;
    PAGE_NUMBER -= 1;
    /*fetches new data from api and resets the current page*/
    initializePage();
}

/* load next 10 data from api logic*/
function nextPage(){
    /*does not allow to load if you have displayed all data and no more is left */
    if(DATA.length == 0) return;
    PAGE_NUMBER += 1;
    initializePage();
}

/* fetches new data and assigns page number*/
function initializePage(){
    /*get data async function*/
    get_data();
    assignPageNumber();
}

/* reset all the error messages in modal, called everytime submit button is clicked */
function resetInputErrorMsg(){
    const item_list = document.querySelectorAll('.eachrow');

    /*eachrow lastelementchild is error displaying div*/
    item_list.forEach((element)=>{
        element.lastElementChild.classList.add('hide');
    });
}

/*initialize page when script starts and assign function to previous page and next page buttons*/
initializePage();
document.getElementById('prev_page').addEventListener('click', prevPage);
document.getElementById('next_page').addEventListener('click', nextPage);