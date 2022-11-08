const loginBtn = document.getElementById('login');
const signupBtn = document.getElementById('signup');
let email;
let password;

function nextinfo() {
    const userInfoNext = document.getElementById('firstInfo');
    const userInfo = document.getElementById('secondInfo');
    const nextBtn = document.getElementById('signup_next');

    email = document.querySelector('.signup #email').value;
    password = document.querySelector('.signup #password').value;
    const repeatPassword = document.getElementById('repeatPassword').value;
    const checkNumber = password.search(/[0-9]/g);
    const checkEnglish = password.search(/[a-z]/ig);
    const emailCheck = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
 
    // Email
    if(emailCheck.test(email)) {
        if(!/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/.test(password)){            
            alert('숫자+영문자+특수문자 조합으로 8자리 이상 사용해야 합니다.');
        }else if(checkNumber <0 || checkEnglish <0){
            alert("숫자와 영문자를 혼용하여야 합니다.");
        }else if(/(\w)\1\1\1/.test(password)){
            alert('같은 문자를 4번 이상 사용하실 수 없습니다.');
        }else if(password != repeatPassword) {
            alert("Repeat Password Uncorrect");
        } else {
            userInfoNext.style.display ='none';
            nextBtn.style.display ='none';
            userInfo.style.display = 'block';
        }
    } else {
        alert('Email Error');
    }

}

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
        password: document.querySelector('.login #password').value,
    };
    sendPost('/login', data);
};

// Sign Up
function signupSubmit() {
    const name = document.querySelector('.signup #name').value;
    const language = document.querySelector('.signup #language').value;
    const company = document.querySelector('.signup #company').value;

    const data = {
        email : email,
        password : password,
        name: name,
        language: language,
        company: company,
        img_url: 'default_profile.png'
    }

    sendPost('/login/signup', data);
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