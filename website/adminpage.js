const BACKEND_URL = 'http://127.0.0.1:5000/';
let page_number = 1
let data = []

async function get_data(){
    // data = []
    data = [
        {"bookingID":3,"empID":1,"travelPurpose":"morning","expectedDist":42,"pickupDateTime":"01:03 AM 04-08-2022","pickupVenue":"morning","arrivalDateTime":"01:00 AM 04-08-2022","additionalInfo":null,"mngID":5,"isApproved":true,"requestDateTime":"10:33 AM 04-08-2022", "hasInfoFilled":true},
        {"bookingID":2,"empID":1,"travelPurpose":"timepass","expectedDist":20.8,"pickupDateTime":"03:59 PM 31-07-2022","pickupVenue":"kolkata","arrivalDateTime":"09:40 PM 31-07-2022","additionalInfo":null,"mngID":5,"isApproved":true,"requestDateTime":"04:00 PM 31-07-2022", "hasInfoFilled":false},
        {"bookingID":1,"empID":1,"travelPurpose":"business","expectedDist":7.5,"pickupDateTime":"10:00 AM 08-01-2022","pickupVenue":"office","arrivalDateTime":"11:00 AM 08-01-2022","additionalInfo":null,"mngID":5,"isApproved":null,"requestDateTime":"09:00 AM 08-01-2022", "hasInfoFilled":false}
    ]
    // try{
    //     response = await fetch(BACKEND_URL + 'getbookingrequests',
    //     {method: 'POST',
    //     headers: {'Content-Type':'application/json'},
    //     body: JSON.stringify({"num":page_number}),
    //     });

    //     data = await response.json();
    // } catch (err) {
    //     alert('Connectivity Issue');
    // }

    if(data.length == 0 || data === undefined || data === null){
        window.document.querySelector('.content-box').innerHTML = `<span style="position:relative;
        left:50%;right:50%;top:50%;bottom:50%;">
        No Content</span>`;

        return;
    }

    display_data(data);
}


function display_data(data){

    if(data.length == 0 || data === undefined || data === null){
        window.document.querySelector('.content-box').innerHTML = `<span style="position:relative;
        left:50%;right:50%;top:50%;bottom:50%;">
        No Content</span>`
        return;
    }

    data.forEach((element, index) => {
        approvalStatus = element.isApproved == null ? 'No Update' : (element.isApproved == true ? 'Approved' : 'Rejected')
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
                new_btn.textContent = 'Set Vehicle Information';
            } else {
                new_btn.textContent = 'View Vehicle Information'
            }
            new_card.appendChild(new_div);


            // new_card.innerHTML+=
            // `<div class="rowitems"><button type="button" class="btn-class">Set Vehicle Information</button></div>`
        }

        window.document.querySelector('.content-box').appendChild(new_card);
    });
}

function createNewInfoModal(){
    booking_id = event.target.parentNode.parentNode.id;
    booking_id = data[booking_id.charAt(booking_id.length-1)].bookingID;

    const modal = document.getElementById('modal');
    const modalHtml = `
        <button type="button" class="close-btn" id="close-btn">X</button>
        <span style="font-family: 'Segoe UI';">Fill Information For booking id: ${booking_id}</span>
        <div class="eachrow"><span class="heading">Vehicle Registration Number: </span><input id="vehRegNum"></div>
        <div class="eachrow">
            <span class="heading">Vehicle Model: </span><input id="vehModel">
        </div>
        <div class="eachrow">
            <span class="heading">License Expiry Date: </span><input id="licenseExp" type="date">
        </div>
        <div class="eachrow">
            <span class="heading">Insurance Expiry Date: </span><input id="insuranceExp" type="date">
        </div>
        <div class="eachrow">
            <span class="heading">PUC Expiry Date: </span><input id="pucExp" type="date">
        </div>
        <div class="eachrow">
            <span class="heading">Driver Name: </span><input id="driverName">
        </div>
        <div class="eachrow">
            <span class="heading">Driver Address: </span><input id="driverAddress">
        </div>
        <div class="eachrow">
            <span class="heading">License Number: </span><input id="licenseNumber">
        </div>
        <div class="eachrow">
            <span class="heading">Driver Contact Information: </span><input id="driverContact" type="tel">
        </div>
        <div class="eachrow">
            <span class="heading">Travel Agent Contact: </span><input id="travContact" type="tel">
        </div>
        <button type="button" id="submit" class="btn-class" style="left:50%; transform: translate(-50%); margin-top: 18px;">Submit</button>
        `
        togglemodal();
        modal.innerHTML = modalHtml;
        modal.querySelector('.close-btn').addEventListener('click', togglemodal);
        // document.getElementById('modal').classList.toggle('hide');
}

function togglemodal(){
    // createModal
    // document.getElementById('close-btn').classList.toggle('hide');
    document.getElementById('modal').classList.toggle('hide');
    document.body.classList.toggle('hide-body');
    // document.body.childNodes.disabled = true;
}

function createViewInfoModal(){
    console.log('view info');
}

function assigneventlistener(){
    // btn = document.querySelectorAll('.btn-class');
    content_view = document.querySelectorAll('.content');
    console.log(content_view);
    content_view.forEach((element)=>{
        
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

get_data().then(assigneventlistener);