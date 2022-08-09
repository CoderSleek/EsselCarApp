
data = [{'bookingID':1,'empID':1}, {'bookingID':2,'empID':2},]

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
    <div class="rowitems"><button type="button" class="btn-class">Click me</button></div>
`

    const new_card = document.createElement('div');
    new_card.classList = 'content';
    new_card.id = 'card'+index;
    new_card.innerHTML += itemContent
    if(index == 0){
        // console.log(index)
        btn = new_card.querySelector('.btn-class');
        btn.disabled = true;
    }
    window.document.querySelector('.content-box').appendChild(new_card)
    
});

// for(let i =0; i < 5; ++i){
//     const item = new_card_creator(i)
//     item.innerHTML += itemContent
    
// }

// function new_card_creator(i){

//     return new_card;
// }