var peer = new Peer();

peer.on('open', function(id) {
    document.getElementById('yourId').value = id;
});

document.getElementById('connect').addEventListener('click', function () {
    var otherId = document.getElementById('otherId').value;
    var conn = peer.connect(otherId);
    // on open will be launch when you successfully connect to PeerServer
    conn.on('open', function(){
        // here you have conn.id
        console.log("Connection Opened Successfully!!");
        startSession(otherId);
        conn.on('data', function(data) {
            console.log('Received on Data', data);
            document.getElementById('messages').textContent += data + '\n';
          });

        conn.send('hi!');
        document.getElementById('messages').textContent += yourMessage + '\n';
    });
});


peer.on('connection', function(conn) {
    conn.on('data', function(data){
        console.log('Received on Connection', data);
        document.getElementById('messages').textContent += data + '\n';
    });
    conn.on('open', function(){
        console.log("Connection Opened Successfully!!");
        var otherId = document.getElementById('otherId').value;
        startSession(otherId);
    });
});



function startSession(otherId){
    var getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    getUserMedia({video: true, audio: true}, function(stream) {

        var call = peer.call(otherId, stream);

        peer.on('call', function(call) {
            // Answer the call, providing our mediaStream
            call.answer(stream);
        });

        call.on('stream', function(remoteStream) {
            // Show stream in some video/canvas element.
            console.log("video streaming..");
            var audio = document.createElement('video');
            audio.style.width = '100%';
            document.body.appendChild(audio);
            if('srcObject' in audio) {
                audio.srcObject = remoteStream;
            } else {
                audio.src = window.URL.createObjectURL(remoteStream); // for older browsers
            }
            audio.play();
        });

    }, function(err) {
        console.log('Failed to get local stream' ,err);
    });
}