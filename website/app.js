async function verifyLogin(){
    const uname = document.getElementById('uname').value;
    const pass = document.getElementById('pass').value;

    try{
        let response = await fetch(backend_url+'admincredcheck',
            {
                method: 'POST',
                headers:{'Content-Type':'application/json'}, 
                body: JSON.stringify({'uname': uname,'password':pass})
            });

        if(response.status == 401){
            alert('Invalid id or password');
            return;
        }
        let token = await response.json()

        if(token){
            sessionStorage.setItem('accessToken', token);
            window.location.href = backend_url+'adminpage';
            // let response = await fetch(backend_url+'adminpage',
            // {
            //     method: 'GET',
            //     headers:{
            //         'Content-Type':'application/json',
            //         'Authorization': token,
            //         'Access-Control-Allow-Origin': 'no-cors',
            //     }
            // });
            // html_text = await response.text();
            // document.querySelector('html').innerHTML = html_text;
        }
    } catch (err) {
        alert('Some error Occured');
        console.log(err);
    }
}

const backend_url = 'http://localhost:5000/';

const logInBtn  = window.document.getElementById('login')
logInBtn.addEventListener('click', verifyLogin)