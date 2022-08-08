
data = [{'bookingID':1,'empID':1}, {'bookingID':2,'empID':2}]

data.forEach((element,index) => {
    const itemContent = 
`
    <div class="rowitems">
        <div class="eachitem"><span class="heading">Booking id:</span>${element.bookingID}</div>
        <div class="eachitem"><span class="heading">User id:</span>${element.empID}</div>
        <div class="eachitem"><span class="heading">Purpose:</span>${element.empID}</div>
    </div>
    <div class="rowitems">
        <div class="eachitem"><span class="heading">Booking id:</span>1</div>
        <div class="eachitem"><span class="heading">Booking id:</span>1</div>
    </div>
`

    const new_card = document.createElement('div');
    new_card.classList = 'content';
    new_card.id = 'card'+index;
    new_card.innerHTML += itemContent
    window.document.querySelector('.content-box').appendChild(new_card)
});

// for(let i =0; i < 5; ++i){
//     const item = new_card_creator(i)
//     item.innerHTML += itemContent
    
// }

// function new_card_creator(i){

//     return new_card;
// }