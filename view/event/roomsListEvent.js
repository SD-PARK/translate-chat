const socket = io.connect(window.location.host + '/roomsList', {path: '/socket.io'});

socket.emit('view', (document.cookie.split('=')[1]), (res) => {
    // 즐겨찾기한 대화방 출력
    for(let i = res.favorites_result.length-1; i>=0; i--) {
        roomPrint(res.favorites_result[i]);
    }
    // 그 외의 대화방 출력
    for(let i = res.normal_result.length-1; i>=0; i--) {
        roomPrint(res.normal_result[i]);
    }
});

function roomPrint(info) {
    // ROOM_ID, ROOM_NAME, SEND_TIME, MSG
    let timeAs = new Date(info.SEND_TIME); // 가공
    const today = new Date(new Date().toLocaleDateString());

    if(timeAs >= today) timeAs = timeAs.toLocaleTimeString().slice(-8, -3);
    else timeAs = timeAs.toLocaleDateString().substring(6);

    $('#rows').append(`<div class="row room" onclick="location.href='room/${info.ROOM_ID}'">
                            <img src="../img/room_add_btn.png"/>
                            <p>
                                <strong>${info.ROOM_NAME}</strong><br>
                                <div>${info.MSG}</div>
                            </p>
                            <a>${timeAs}</a>
                        </div>`);
}