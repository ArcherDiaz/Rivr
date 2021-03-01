var peer = new Peer();

peer.on('open', function(id) {
    document.getElementById('yourId').value = id;
});

peer.on('connection', function(conn) {
    console.log("Connection Opened Successfully!! : 2");
    
    conn.on('data', function(data){
        console.log('Received on Connection', data);
        document.getElementById('messages').textContent += data + '\n';
    });
});

peer.on('call', function(call) {
    // Answer the call, providing our mediaStream.
    console.log("Calling!!");
    //var getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true
    }).then(function(stream){
        call.answer(stream);
        startSession(stream, call);
    })
    .catch(function(err){
        console.log("ERROR: " + err);
    });
});



function getPermission(otherId){
    //var getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true
    }).then(function(stream){
        var call = peer.call(otherId, stream);
        startSession(stream, call);
    })
    .catch(function(err){
        console.log("ERROR: " + err);
    });
}

function startSession(stream, call){
    console.log("video streaming..");
    var audio = document.createElement('video');
    audio.style.width = '100%';
    document.body.appendChild(audio);
    if('srcObject' in audio) {
        audio.srcObject = stream;
    } else {
        audio.src = window.URL.createObjectURL(stream); // for older browsers
    }
    audio.play();


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
}


document.getElementById('init').addEventListener('click', function () {
    var otherId = document.getElementById('otherId').value;
    getPermission(otherId);
});

document.getElementById('connect').addEventListener('click', function () {
    var otherId = document.getElementById('otherId').value;
    var conn = peer.connect(otherId);
    // on open will be launch when you successfully connect to PeerServer
    conn.on('open', function(){
        console.log("Connection Opened Successfully!! : 1");
        // // here you have conn.id
        // console.log("Connection Opened Successfully!! : 1");
        // startSession(otherId);
        // conn.on('data', function(data) {
        //     console.log('Received on Data', data);
        //     document.getElementById('messages').textContent += data + '\n';
        // });

        var message = "hi!";
        conn.send(message);
        document.getElementById('messages').textContent += message + '\n';
    });
});