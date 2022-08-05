async function verifyLogin(){
    const uname = document.getElementById('uname').value;
    const pass = document.getElementById('pass').value;

    let x = await fetch(backend_url, {method: 'POST', mode:'no-cors', headers:{'Content-Type':'application/json'}, 
        body:JSON.stringify({'uname':uname, 'password':pass})});
    // console.log({'uname':uname, 'password':pass})
    // console.log(JSON.stringify({'uname':uname, 'password':pass}))
    // let x = await fetch(backend_url, {method: 'POST', mode:'no-cors', headers:{'Content-Type':'application/json'}, 
    //     body:{"uname":`${uname}`, "password":`${pass}`}});
    
    // console.log(JSON.stringify({"uname":`${uname}`, "password":`${pass}`}))
    console.log(x.headers)
}

const backend_url = 'http://localhost:5000/adminlogin';

const logInBtn  = window.document.getElementById('login')
logInBtn.addEventListener('click', verifyLogin)