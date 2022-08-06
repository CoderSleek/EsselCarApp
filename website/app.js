async function verifyLogin(){
    const uname = document.getElementById('uname').value;
    const pass = document.getElementById('pass').value;

    try{
        let response = await fetch('http://localhost:5000/admincredcheck',
            {method: 'POST', headers:{'Content-Type':'application/json'}, 
            body: JSON.stringify({'uname': uname,'password':pass})});

        let body = await response.json()
        console.log(body)
    } catch (err) {
        alert('Network error')
    }
}

const backend_url = 'http://localhost:5000/';

const logInBtn  = window.document.getElementById('login')
logInBtn.addEventListener('click', verifyLogin)