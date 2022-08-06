async function verifyLogin(){
    const uname = document.getElementById('uname').value;
    const pass = document.getElementById('pass').value;

    try{
        let response = await fetch(backend_url, {method: 'POST',
            headers:{'Content-Type':'application/json'}, 
            body: JSON.stringify({'uname': uname,'password':pass})});
    } catch (err) {
        alert('Network error')
    }

    let body = await response.json()
    console.log(body)
}

const backend_url = 'http://localhost:5000/adminlogin';

const logInBtn  = window.document.getElementById('login')
logInBtn.addEventListener('click', verifyLogin)