const socket = io.connect(window.location.host + '/room', {path: '/socket.io'});

const user_id = get_cookie('id'); // 쿠키에서 user_id 값 추출
function get_cookie(name) {
    var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return value? value[2] : null;
}
const room_id = window.location.pathname.substring(12); // url에서 room_id 값 추출
let dateCheck;

let msg = [];
// Room 입장 이벤트
socket.emit('join', {user_id: user_id, room_id: room_id}, (title, res) => {
    let msg_length = res.length;
    let date;
    if(res === 'No permissions')
        return alert(res);

    $('#topmenu input.title').attr('value', title);
    $("#Untranslated").css('display', 'none');
    console.log(res);
    msg = res;
    for(let i=0; i<msg_length; i++) {
        datePrint(new Date(res[i].SEND_TIME).toLocaleDateString()); // 날짜 확인
        if(res[i].SEND_USER_ID == user_id) { // 본인 메세지와 상대 메세지 구분
            selfChat(res[i], date);
        } else {
            personChat(res[i], date);
        }
    }
    $("#chat-messages").scrollTop($("#chat-messages")[0].scrollHeight);
});

/** 입력받은 날짜가 이전 대화의 날짜와 다르면 날짜 출력 */
function datePrint(date) {
    if(dateCheck != date) {
        addSpace(1);
        $('#chat-messages').append(`<label>${date}</label>`);
        addSpace(1);
        dateCheck = date;
    }
}
/** 다른 사람의 대화 (좌측 말풍선) */
function personChat(chat) {
    date = new Date(chat.SEND_TIME).toLocaleTimeString().slice(0, -3);
    $('#chat-messages').append(`<div class="message">
        <img src="../../img/profiles/${chat.IMG_URL}"/>
        <strong>${chat.NAME}</strong>
        <div class="bubble"><div id="msg_${chat.MSG_NUM}">${chat.MSG}</div><div class="corner"></div>
            <span class="dateLeft">${date}</span>
            <button id="btn_${chat.MSG_NUM}" class="originalBtn" onclick="textSwitch(${chat.MSG_NUM})"></button>
        </div>
    </div>`);
}
/** 본인의 대화 (우측 말풍선) */
function selfChat(chat) {
    date = new Date(chat.SEND_TIME).toLocaleTimeString().slice(0, -3);
    $('#chat-messages').append(`<div class="message right">
        <img src="../../img/profiles/${chat.IMG_URL}" />
        <div class="bubble"><div id="msg_${chat.MSG_NUM}">${chat.MSG}</div><div class="corner"></div>
            <span>${date}</span>
        </div>
    </div>`);
}
/** 여백 추가(여백 길이, 자연수) */
function addSpace(num) {
    for(let i=0; i<num; i++)
        $('#chat-messages').append(`<div id="space"></div>`);
}

const msgInput = document.querySelector('#msgInput');
msgInput.addEventListener('keypress', (e) => {
  if (e.key === "Enter") {
    e.preventDefault();
    sendMessage();
  }
});
/** 메세지 전송 */
function sendMessage() {
    if(msgInput.value.trim()) {
        socket.emit('sendMsg', (msgInput.value));
        msgInput.value = null;
    }
}

socket.on('tellNewMsg', (MSG_NUM) => {
    socket.emit('callNewMsg', (MSG_NUM), (newMsg) => {
        msg.push(newMsg);
        datePrint(new Date(newMsg.SEND_TIME).toLocaleDateString()); // 날짜 확인
        if (newMsg.SEND_USER_ID == user_id) {
            selfChat(newMsg);
        } else {
            personChat(newMsg);
        }
        $("#chat-messages").scrollTop($("#chat-messages")[0].scrollHeight); // 스크롤 맨 아래로
    });
});

/** Room 제목 변경 */
$('#topmenu input.title').change(() => {
    console.log($('#topmenu input.title').val());
    socket.emit('roomTitleChange', $('#topmenu input.title').val());
});

/** 메세지 원문/번역문 전환 */
function textSwitch(msgNum) {
    let originalMsg = msg[msgNum-1].ORIGINAL_MSG; // 원문
    let translateMsg = msg[msgNum-1].MSG; // 번역문
    if (msg[msgNum-1].switch) {
        $(`#msg_${msgNum}`).empty();
        $(`#msg_${msgNum}`).append(translateMsg);
        $(`#btn_${msgNum}`).css('background-image', 'url("../../img/original_text_btn.png")');
        msg[msgNum-1].switch = 0;
    } else {
        $(`#msg_${msgNum}`).empty();
        $(`#msg_${msgNum}`).append(originalMsg);
        $(`#btn_${msgNum}`).css('background-image', 'url("../../img/translate_text_btn.png")');
        msg[msgNum-1].switch = 1;
    }
}

/** 메뉴 버튼 클릭 시 모달 On/Off */
function modalBtnClick() {
    if ($('#menuModal').css('display') == 'none') {
        $('#menuModal').show();
    } else {
        $('#menuModal').hide();
    }
}

/** 친구 초대 */
function inviteBtnClick() {
    $('.modal').show();
    socket.emit('friendsSearch', ($('#searchText').val()), (list) => {
        window.list = list;
        modalUpdate();
    });
}

/** Modal 닫기 */
function modalClose() {
    $(".modal").css('display', 'none');
}
// 팝업 창 외부 영역 클릭 시
$(window).click((e) => {
    if ($(e.target).is($('.modal'))) {
        $(".modal").css('display', "none");
    }
});

// ======= Search Event ======= //
$(document).ready(() => {
    // 검색 창에 입력 시
    $('#searchText').keyup(() => {
        socket.emit('friendsSearch', ($('#searchText').val()), (list) => {
            window.list = list;
            modalUpdate();
        });
    });
});

// ======= Select Event ======= //
let list = [];
let inviteIdArr = [];
/** Select Field 갱신 */
function modalUpdate() {
    $('#modalSelect').empty(); // 기존 검색 내용 제거
    let len = window.list.length;
    for(let i=0; i<len; i++) {
        let checked = (inviteIdArr.indexOf(window.list[i].ID) == -1) ? '' : 'checked';
        $('#modalSelect').append(`<div class="selectField">
                                    <img src="../../img/profiles/${window.list[i].IMG_URL}"/>
                                    <p>
                                        <strong>${window.list[i].NAME}</strong><br>
                                        <span>${window.list[i].EMAIL}</span>
                                    </p>
                                    <input type="checkbox" onclick="addInvite(${window.list[i].ID}, ${i})" ${checked}></div>`);
    }
}
/** Invite 추가 */
function addInvite(id, i) {
    let index = inviteIdArr.indexOf(id);
    if(index == -1) { // 체크되지 않았다면
        inviteIdArr.push(id); // 값 추가
        $('#chooseList').append(`<div class="chooseRow" onclick="inviteRemove(${id})">
                                        <span class="chooseCancel">&times;</span>
                                        <img src="../../img/profiles/${window.list[i].IMG_URL}">
                                        <p>${window.list[i].NAME}</p>
                                    </div>`)
    } else { // 이미 체크된 상태라면
        inviteIdArr = inviteIdArr.filter((element) => element !== id); // 값 제거
        $(`#chooseList .chooseRow:nth-child(${index+1})`).remove();
    }
    console.log(inviteIdArr);
}
/** Invite 상단 X 버튼 눌렀을 때, Invite 제거 */
function inviteRemove(id) { // Invite Event
    let index = inviteIdArr.indexOf(id);
    inviteIdArr = inviteIdArr.filter((element) => element !== id); // 값 제거
    $(`#chooseList .chooseRow:nth-child(${index+1})`).remove();
    modalUpdate(window.list);
}

// ======= Submit Event ======= //
function inviteRoom() {
    if(inviteIdArr.length) {
        socket.emit('inviteRoom', inviteIdArr, (callback) => {
            // Modal 닫기
            modalClose();
            // 채팅방 목록 갱신
            socket.emit('view', (user_id), (res) => {
                console.log(res);
                roomPrintMid(res);
            });
        });
    } else {
        alert('You must invite at least one person.');
    }
}