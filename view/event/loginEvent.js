console.clear();

const loginBtn = document.getElementById('login');
const signupBtn = document.getElementById('signup');

loginBtn.addEventListener('click', (e) => {
let parent = e.target.parentNode.parentNode;
Array.from(e.target.parentNode.parentNode.classList).find((element) => {
    if(element == "slide-up") {
        signupBtn.parentNode.classList.add('slide-up')
        parent.classList.remove('slide-up')
    }
});
});

signupBtn.addEventListener('click', (e) => {
let parent = e.target.parentNode;
Array.from(e.target.parentNode.classList).find((element) => {
    if(element == "slide-up") {
    loginBtn.parentNode.parentNode.classList.add('slide-up')
    parent.classList.remove('slide-up')
    }
});
});

// Log in
function loginSubmit() {
    const data = {
    email: document.querySelector('.login #email').value,
    password: document.querySelector('.login #password').value
    };
    sendPost('/login', data);
};

// Sign Up
function signupSubmit() {
let email = document.querySelector('.signup #email').value;
let password = document.querySelector('.signup #password').value;
let repeatPassword = document.querySelector('.signup #repeatPassword').value;
// 오류 검사
// email 확인

// password 확인
if (password === repeatPassword) {
    const data = {
    email: email,
    password: password,
    };
    sendPost('/login/signup', data);
}
};

// POST 전송
function sendPost(url, params) {
var form = document.createElement('form');
form.setAttribute('method', 'post');
form.setAttribute('action', url);
document.charset = 'utf-8';
for (let key in params) {
    const hiddenField = document.createElement('input');
    hiddenField.setAttribute('type', 'hidden');
    hiddenField.setAttribute('name', key);
    hiddenField.setAttribute('value', params[key]);
    form.appendChild(hiddenField);
}
document.body.appendChild(form);
form.submit();
}