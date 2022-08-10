const BACKEND_URL = 'http://127.0.0.1/'
let page_number = 1

function get_data(){
    response = await fetch(BACKEND_URL + 'getbookingrequests',
    {method: 'post', body: JSON.stringify(page_number),
    headers: {'Content-Type':'application/json'}})

    let data = await response.json()

    data = []
    if(!data){
        window.document.querySelector('.content-box').textContent = 'No Data'
    }

    display_data();
}


function display_data(){
    data.forEach((element, index) => {
        const itemContent = 
    `
        <div class="rowitems">
            <div class="eachitem"><span class="heading">Booking id:</span>${element.bookingID}</div>
            <div class="eachitem"><span class="heading">User id:</span>${element.empID}</div>
            <div class="eachitem"><span class="heading">Purpose:</span>${element.bookingID}</div>
        </div>
        <div class="rowitems">
            <div class="eachitem"><span class="heading">Expected Distance: </span>${element.bookingID}</div>
            <div class="eachitem"><span class="heading">Pickup Venue: </span>${element.bookingID}</div>
            <div class="eachitem"><span class="heading">Approval Status: </span>${element.bookingID}</div>
        </div>
        <div class="rowitems">
            <div class="eachitem"><span class="heading">Pickup Date & Time:</span>${element.bookingID}</div>
            <div class="eachitem"><span class="heading">Arrival Date & Time:</span>${element.bookingID}</div>
            <div class="eachitem"><span class="heading">Request Date & Time:</span>${element.bookingID}</div>
        </div>
        <div class="rowitems">
            <div class="eachitem"><span class="heading">Manager ID: </span>${element.bookingID}</div>
            <div class="eachitem"><span class="heading">Additional Information: </span>${element.bookingID}</div>
        </div>
        <div class="rowitems"><button type="button" class="btn-class">${'a'}</button></div>
    `

        const new_card = document.createElement('div');
        new_card.classList = 'content';
        new_card.id = 'card'+index;
        new_card.innerHTML += itemContent
        // if(index){
        //     btn = new_card.querySelector('.btn-class');
        //     btn.disabled = true;
        // }
        window.document.querySelector('.content-box').appendChild(new_card)  
    });
}

get_data()
display_data()

btn = document.querySelectorAll('.btn-class')
btn.forEach((element)=>{
    element.addEventListener('click', )
})