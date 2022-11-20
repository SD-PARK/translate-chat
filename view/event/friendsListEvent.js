const socket = io.connect(window.location.host + '/friendsList', {path: '/socket.io'});

const user_id = get_cookie('id');
function get_cookie(name) {
    var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return value? value[2] : null;
}

socket.emit('view', (user_id), (res) => {
    printMid(res, 1);
});

function printMid(res, i) {
    const res_len = res.friends_result.length;
    $('#rows').empty();
    // 개인 프로필 출력
    if(i) { selfPrint(res.user_result); }
    // 친구 프로필 출력
    for(let i=0; i<res_len; i++) {
        friendPrint(res.friends_result[i]);
    }
}

function selfPrint(info) {
    $('#rows').append('<div class="divide"><strong>My Profile</strong></div>');
    friendPrint(info);
    $('#rows').append('<div class="divide"><strong>Friends Profile</strong></div>');
}

function friendPrint(info) { // location.href='profile/${info.ID}
    $('#rows').append(`<div class="row friend" onclick="'">
                            <img src="../img/profiles/${info.IMG_URL}"/>
                            <p>
                                <img src="../img/flag/${info.LANGUAGE}.png">
                                <strong>${info.NAME}</strong><br>
                                <span>${info.EMAIL}</span>
                            </p>
                            <div class="status inactive"></div>
                        </div>`);
                        // status = (available, away, inactive)
}

// ======= Modal Event ======= //
/** 하단 Modal 버튼 클릭 */
function modalBtnClick() {
    $("#myModal").css('display', 'block');
}
// 팝업 창 외부 영역 클릭 시
$(window).click((e) => {
    if ($(e.target).is($('#myModal'))) {
        modalClose();
    }
});
/** Modal 닫기 */
function modalClose() {
    $("#myModal").css('display', 'none');
    socket.emit('view', (user_id), (res) => { // 친구 목록 갱신
        printMid(res, 1);
    });
}

// ======= Search Event ======= //
$(document).ready(() => {
    // 친구 목록 내 검색
    $('#searchfield').keyup(() => {
        let text = $('#searchfield').val();
        if(text) {
            socket.emit('friendSearch', (text), (res) => {
                console.log(res);
                printMid({friends_result: res}, 0);
            });
        } else {
            socket.emit('view', (user_id), (res) => {
                printMid(res, 1);
            });
        }
    });
    // 친구 목록 외 검색
    $('#searchText').keyup(() => {
        let text = $('#searchText').val();
        if(text) {
            socket.emit('emailSearch', (text), (list) => {
                window.list = list;
                modalUpdate();
            });
        } else {
            $('#modalSelect').empty();
        }
    });
});

// ======= Select Event ======= //
/** Select Field 갱신 */
let list = [];
let reg_list = [];
function modalUpdate() {
    $('#modalSelect').empty(); // 기존 검색 내용 제거
    let len = window.list.length;
    for(let i=0; i<len; i++) {
        $('#modalSelect').append(`<div class="selectField">
                                    <img src="../img/profiles/${window.list[i].IMG_URL}"/>
                                    <p>
                                        <img src='../img/flag/${window.list[i].LANGUAGE}.png'></img>
                                        <strong>${window.list[i].NAME}</strong><br>
                                        <span>${window.list[i].EMAIL}</span>
                                    </p>
                                    <input type="checkbox" onclick="friendRegister(${window.list[i].ID}, ${i})"></input></div>`);
    }
}
/** 친구 등록 */
function friendRegister(id, i) {
    if(reg_list.indexOf(id) == -1) {
        socket.emit('friendRegister', id);
        reg_list.push(id);
        $(`.selectField:nth-child(${i+1}) input`).attr('disabled', true);
    }
}