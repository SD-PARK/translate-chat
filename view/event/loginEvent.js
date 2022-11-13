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
 
    userInfoNext.style.display ='none';
    nextBtn.style.display ='none';
    userInfo.style.display = 'block';
    // // Email
    // if(emailCheck.test(email)) {
    //     if(!/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/.test(password)){            
    //         alert('It must be at least 8 characters with a combination of numbers, English, and special characters.');
    //     }else if(checkNumber <0 || checkEnglish <0){
    //         alert("You must mix letters and numbers.");
    //     }else if(/(\w)\1\1\1/.test(password)){
    //         alert('The same character cannot be used more than 4 times.');
    //     }else if(password != repeatPassword) {
    //         alert("The repeat password is different");
    //     } else {
    //         userInfoNext.style.display ='none';
    //         nextBtn.style.display ='none';
    //         userInfo.style.display = 'block';
    //     }
    // } else {
    //     alert('Email format is incorrect.');
    // }
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

/** 이미지 업로드 */
function PreviewImage() {
    var preview = new FileReader();
    preview.onload = (e) => {
        document.getElementById("user_image").src = e.target.result; // img id 값 
        console.log(e.target.result);
    };
    preview.readAsDataURL(document.getElementById("user_profile_img").files[0]); // input id 값
    // console.log(preview.readAsDataURL(document.getElementById("user_profile_img").files[0])); //data: image/png
    //  // http://localhost:3000/img/default_profile.jpg
    //  (document.getElementById("user_image").src).substr(26);
};