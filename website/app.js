async function verifyLogin(){
    const uname = document.getElementById('uname').value;
    const pass = document.getElementById('pass').value;

    let x = await fetch(backend_url, {method: 'POST', body:{'uname':uname,
        'password':pass}});
    console.log(x)
}

const backend_url = 'http://127.0.0.1:5000/adminlogin';

const logInBtn  = window.document.getElementById('login')
logInBtn.addEventListener('click', verifyLogin)