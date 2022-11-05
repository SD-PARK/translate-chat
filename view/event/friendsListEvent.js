const socket = io.connect('http://localhost:3000/friendsList', {path: '/socket.io'});

socket.emit('view', (document.cookie.split('=')[1]), (res) => {
    // 개인 프로필 출력
    friendPrint(res.user_result);
    // 친구 프로필 출력
    for(let i = res.friends_result.length-1; i>=0; i--) {
        friendPrint(res.friends_result[i]);
    }
});

function friendPrint(info) {
    $('#friends').append(`<div class="friend">
                            <img src="../img/${info.IMG_URL}"/>
                            <p>
                                <strong>${info.NAME}</strong><br>
                                <span>${info.EMAIL}</span>
                            </p>
                            <div class="status inactive"></div>
                        </div>`);
                        // status = (available, away, inactive)
}