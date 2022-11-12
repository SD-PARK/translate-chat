const socket = io.connect(window.location.host + '/room', {path: '/socket.io'});

const user_id = get_cookie('id'); // 쿠키에서 user_id 값 추출
function get_cookie(name) {
    var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return value? value[2] : null;
}
const room_id = window.location.pathname.substring(12); // url에서 room_id 값 추출
let dateCheck;

// Room 입장 이벤트
socket.emit('join', {user_id: user_id, room_id: room_id}, (res) => {
    let msg_length = res.length;
    let date;

    if(res === 'No permissions')
        return alert(res);

    $("#Untranslated").css('display', 'none');
    
    for(let i=0; i<msg_length; i++) {
        datePrint(new Date(res[i].SEND_TIME).toLocaleDateString()); // 날짜 확인
        if(res[i].SEND_USER_ID == user_id) { // 본인 메세지와 상대 메세지 구분
            selfChat(res[i]);
        } else {
            personChat(res[i]);
        }
    }
    addSpace(2);
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
    $('#chat-messages').append(`<div class="message">
        <img src="../../img/${chat.IMG_URL}"/>
        <div class="bubble">${chat.MSG}<div class="corner"></div>
            <span>${new Date(chat.SEND_TIME).toLocaleTimeString().slice(0, -3)}</span>
        </div>
    </div>`);
}
/** 본인의 대화 (우측 말풍선) */
function selfChat(chat) {
    $('#chat-messages').append(`<div class="message right">
        <img src="../../img/${chat.IMG_URL}" />
        <div class="bubble">${chat.MSG}<div class="corner"></div>
            <span>${new Date(chat.SEND_TIME).toLocaleTimeString().slice(0, -3)}</span>
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
    socket.emit('roomTitleChange', $('#topmenu input.title').value);
});