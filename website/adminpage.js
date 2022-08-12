const BACKEND_URL = 'http://127.0.0.1:5000/';
let page_number = 1

async function get_data(){
    let data = []
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
        <div class="rowitems"><button type="button" class="btn-class">Set Vehicle Information</button></div>
    `

        const new_card = document.createElement('div');
        new_card.classList = 'content';
        new_card.id = 'card'+index;
        new_card.innerHTML += itemContent
        // if(element.isApproved !== true){
        //     btn = new_card.querySelector('.btn-class');
        //     btn.disabled = true;
        // }
        window.document.querySelector('.content-box').appendChild(new_card)
    });
}

function togglemodal(){
    document.getElementById('modal').classList.toggle('hide');
    // document.getElementById('close-btn').classList.toggle('hide');
    document.body.classList.toggle('hide-body');
    document.body.childNodes.disabled = true;
}

function assigneventlistener(){
    btn = document.querySelectorAll('.btn-class');
    btn.forEach((element)=>{
        element.addEventListener('click', togglemodal);
    })
}

get_data().then(assigneventlistener);

document.getElementById('close-btn').addEventListener('click', togglemodal)