async function verifyLogin(){
    const uname = document.getElementById('uname').value;
    const pass = document.getElementById('pass').value;

    try{
        // let response = await fetch(backend_url+'admincredcheck',
        //     {method: 'POST', headers:{'Content-Type':'application/json'}, 
        //     body: JSON.stringify({'uname': uname,'password':pass})});

        // let token = await response.json()
        let token = true;

        // console.log(body)


        if(token){
            window.location.href = backend_url+'adminpage?token='+token;
            // console.log('fetching')
            // fetch(backend_url+'adminpage', {method: 'get', headers:{'Content-Type':'application/json'},
            // body:JSON.stringify({"token":"randomstuff"})})
        }
    } catch (err) {
        alert('Some error Occured')
    }
}

const backend_url = 'http://localhost:5000/';

const logInBtn  = window.document.getElementById('login')
logInBtn.addEventListener('click', verifyLogin)