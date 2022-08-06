async function verifyLogin(){
    const uname = document.getElementById('uname').value;
    const pass = document.getElementById('pass').value;

    try{
        let response = await fetch(backend_url+'admincredcheck',
            {method: 'POST', headers:{'Content-Type':'application/json'}, 
            body: JSON.stringify({'uname': uname,'password':pass})});

        let body = await response.json()
        console.log(body)
        // if(body){
        //     window.location.href = backend_url+'adminpage';
        // }
    } catch (err) {
        alert('Network error')
    }
}

const backend_url = 'http://localhost:5000/';

const logInBtn  = window.document.getElementById('login')
logInBtn.addEventListener('click', verifyLogin)