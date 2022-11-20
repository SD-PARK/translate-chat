const socket = io.connect(window.location.host + '/roomsList', {path: '/socket.io'});

const user_id = get_cookie('id');
function get_cookie(name) {
    var value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return value? value[2] : null;
}

// 대화방 목록 요청
socket.emit('view', (user_id), (res) => {
    console.log(res);
    roomPrintMid(res);
});

function roomPrintMid(list) {
    let list_len = list.length;
    $('#rows').empty();
    for(let i=0; i<list_len; i++) { // 즐겨찾기한 대화방 출력
        if(list[i].FAVORITES == 1)
            roomPrint(list[i]);
    }
    for(let i=0; i<list_len; i++) { // 그 외의 대화방 출력
        if(list[i].FAVORITES == 0)
            roomPrint(list[i]);
    }
}
/** 대화방 출력 */
function roomPrint(info) {
    // ROOM_ID, ROOM_NAME, SEND_TIME, MSG
    let timeAs;
    if(!!info.LAST_SEND_TIME) { // 시간 값 확인
        timeAs = new Date(info.LAST_SEND_TIME); // 가공
        const today = new Date(new Date().toLocaleDateString());
    
        if(timeAs >= today) timeAs = timeAs.toLocaleTimeString().slice(-8, -3);
        else timeAs = timeAs.toLocaleDateString().substring(6);
    } else {
        timeAs = "";
    }

    $('#rows').append(`<div class="row room" onclick="location.href='room/${info.ROOM_ID}'">
                            <img src="../img/profiles/default_profile.jpg"/>
                            <p>
                                <strong>${info.ROOM_NAME}</strong><br>
                                <div>${info.LAST_MSG}</div>
                            </p>
                            <a>${timeAs}</a>
                        </div>`);
}

updateCheck = setInterval(() => { // 1초마다 서버에 업데이트 여부 확인
    socket.emit('updateCheck', (user_id), (callback) => {
        socket.emit('view', (user_id), (res) => {
            console.log(res);
            roomPrintMid(res);
        });
    });
}, 1000);

// ======= Modal Event ======= //
/** 하단 Modal 버튼 클릭 */
function modalBtnClick() {
    $("#myModal").css('display', 'block');
    // 친구 목록 로드
    socket.emit('friendsSearch', (''), (list) => {
        window.list = list;
        modalUpdate();
    });
}
/** Modal 닫기 */
function modalClose() {
    $("#myModal").css('display', 'none');
}
// 팝업 창 외부 영역 클릭 시
$(window).click((e) => {
    if ($(e.target).is($('#myModal'))) {
        $("#myModal").css('display', "none");
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
                                    <img src="../img/profiles/${window.list[i].IMG_URL}"/>
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
                                        <img src="../img/profiles/${window.list[i].IMG_URL}">
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
function makeRoom() {
    if(inviteIdArr.length) {
        socket.emit('makeRoom', inviteIdArr, () => {
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