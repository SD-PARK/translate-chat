const socket = io.connect(window.location.host + '/settingsList', {path: '/socket.io'});
let userInfo = {};

const user_id = get_cookie('id'); // 쿠키에서 user_id 값 추출
function get_cookie(name) {
    var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return value? value[2] : null;
}

socket.emit('callProfile', (user_id), (profile) => {
    userInfo = profile;
    console.log(userInfo);
    $('#profile_img').attr('src', '../img/profiles/' + userInfo.IMG_URL);
    $('#name').val(userInfo.NAME);
    $('#company').val(userInfo.COMPANY_NAME);
    $("#language").val(userInfo.LANGUAGE).prop("selected", true);
});

/** 이미지 업로드 */
function changeImage() {
    var preview = new FileReader();
    preview.onload = (e) => {
        document.getElementById("profile_img").src = e.target.result; // img id 값
    };
    preview.readAsDataURL(document.getElementById("change_img").files[0]); // input id 값
    console.log($('#change_img'));
    $('#resetCheck').val('0');
    showChangeButton();
}
/** 프로필 이미지 초기화 */
function imageDefault() {
    $('#profile_img').attr('src', '../img/profiles/default_profile.jpg');
    $('#resetCheck').val('1');
    var agent = navigator.userAgent.toLowerCase();
    if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1)) {
        $("#change_img").replaceWith($("#change_img").clone(true));
    }else{
        $("#change_img").val("");
    }
    showChangeButton();
}

/** 유저 정보(Name, Company 등) 변경 */
$(document).ready(() => {
    $('#info input#name').change(() => {
        if($('#info input#name').val() == "") {
            $('#name').val(userInfo.NAME);
        } else {
            showChangeButton();
        }
    });
    
    $('#info input#company').change(() => {
        if($('#info input#company').val() == "") {
            $('#company').val(userInfo.COMPANY_NAME);
        } else {
            showChangeButton();
        }
    });

    $('#language').change(() => {
        showChangeButton();
    });
});

/** Change 버튼 출현 애니메이션 */
function showChangeButton() {
    $('#profile').animate({height: '135px'}, 300);
    setTimeout(() => {
        $('#profile button').animate({bottom: '10px'}, 500);
    }, 300);
}

/** Graphic 클릭 시 */
function setGraphic() {
    if($('.graphicRow').css('height') == '0px') {
        $('.graphicRow').animate({height: '50px', opacity: '1'}, 300);
    } else {
        $('.graphicRow').animate({height: '0px', opacity: '0'}, 300);
    }
}

/** Sound 클릭 시 */
function setSound() {
    if($('.soundRow').css('height') == '0px') {
        $('.soundRow').animate({height: '50px', opacity: '1'}, 300);
    } else {
        $('.soundRow').animate({height: '0px', opacity: '0'}, 300);
    }
}