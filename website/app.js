async function verifyLogin(){
    const uname = document.getElementById('uname').value;
    const pass = document.getElementById('pass').value;

    try{
        let response = await fetch(BACKEND_URL+'admincredcheck', /*endpoint*/
        {
            method: 'POST',
            headers:{'Content-Type': 'application/json'}, 
            body: JSON.stringify({'uname': uname,'password':pass})
        });

        if(response.status == 401){ /*401 not found*/
            alert('Invalid id or password');
            return;
        }
        let token = await response.json(); /*rest call returns jwt token*/

        if(token){
            sessionStorage.setItem('accessToken', token);
            window.location.href = BACKEND_URL+'adminpage'; /*change webpage to another html response by endpoint*/
        }
        // console.log('hello');
    } catch (err) {
        alert('Some error Occured');
    }
}

const BACKEND_URL = 'http://localhost:5000/';

const logInBtn  = window.document.getElementById('login');
logInBtn.addEventListener('click', verifyLogin);