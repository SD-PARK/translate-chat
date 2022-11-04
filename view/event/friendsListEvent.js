const socket = io.connect('http://localhost:3000/friendsList', {path: '/socket.io'});

//socket.emit('connect');

socket.on('friendPrint', (friend) => {
    console.log('friendPrint Loaded');
    $('#friends').append(`<div class="friend">
                            <img src="../img/${friend.IMG_URL}"/>
                            <p>
                                <strong>${friend.NAME}</strong><br>
                                <span>${friend.EMAIL}</span>
                            </p>
                            <div class="status inactive"></div>
                        </div>`);
                        // status = (available, away, inactive)
});