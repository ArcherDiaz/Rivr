var meterElement = document.getElementById('meter');
var callButton = document.getElementById('init');
var connectButton = document.getElementById('connect');
var sendButton = document.getElementById('send');

var peer = new Peer();
window.AudioContext = (window.AudioContext || window.webkitAudioContext);

peer.on('open', function(id) {
    document.getElementById('yourId').value = id;
});

peer.on('connection', function(conn) {
    console.log("Peer: onConnection", "You connected to another peer");
    getPermission(conn.peer);
    
    conn.on('open', function(){
        console.log("Peer: onConnection - conn: onOpen");
    });
    conn.on('data', function(data){
        console.log('Peer: onConnection - conn: onData', data);
        document.getElementById('messages').textContent += data + '\n';
    });
});

peer.on('call', function(call) {
    // Answer the call, providing our mediaStream.
    console.log("You are being Called!!");
    //var getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true
    }).then(function(stream){
        audioMeter(stream);
        call.answer(stream);
        startSession(stream, call);
    })
    .catch(function(err){
        console.log("ERROR: " + err);
    });
});



function getPermission(otherId){
    navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true
    }).then(function(stream){
        audioMeter(stream);
        var call = peer.call(otherId, stream);
        startSession(stream, call);
    })
    .catch(function(err){
        console.log("ERROR: " + err);
    });
}

function startSession(stream, call){
    console.log(" My video streaming.");
    var video = document.createElement('video');
    video.id = "mine";
    video.style.width = '100%';
    video.volume = 0.0;
    document.body.appendChild(video);
    if('srcObject' in video) {
        video.srcObject = stream;
    } else {
        video.src = window.URL.createObjectURL(stream); // for older browsers
    }
    video.play();


    call.on('stream', function(remoteStream) { // Show stream in some video/canvas element.
        console.log("video streaming..");
        var element =  document.getElementById(call.peer);
        if (typeof(element) == 'undefined' || element == null){
            // Does not exist.
            var mediaView = document.createElement('video');
            mediaView.id = call.peer;
            mediaView.style.width = '50%';
            document.body.appendChild(mediaView);
            if('srcObject' in mediaView) {
                mediaView.srcObject = remoteStream;
            } else {
                mediaView.src = window.URL.createObjectURL(remoteStream); // for older browsers
            }
            mediaView.play();
        }
    });
}

function audioMeter(stream){
    var audioContext = new AudioContext();
    var mediaStreamSource = audioContext.createMediaStreamSource(stream);
    var processor = audioContext.createScriptProcessor(2048, 1, 1);

    //mediaStreamSource.connect(audioContext.destination); //this line makes the audio play, we kinda don't want that
    mediaStreamSource.connect(processor);
    processor.connect(audioContext.destination);

    processor.onaudioprocess = function (e) {
        var inputData = e.inputBuffer.getChannelData(0);
        var inputDataLength = inputData.length;
        var total = 0;

        for (var i = 0; i < inputDataLength; i++) {
            total += Math.abs(inputData[i++]);
        }
        
        var rms = Math.sqrt(total / inputDataLength);
        var percentage = rms * 100;
        meterElement.style.width = percentage + '%';
    };
}



connectButton.addEventListener('click', function () {
    var otherId = document.getElementById('otherId').value;
    var conn = peer.connect(otherId);
    // on open will be launch when you successfully connect to PeerServer
    conn.on('open', function(){
        console.log("Connection Opened Successfully!! : 1");

        var message = "hi!";
        conn.send(message);
        document.getElementById('messages').textContent += message + '\n';
    });
});

callButton.addEventListener('click', function () {
    var otherId = document.getElementById('otherId').value;
    getPermission(otherId);
});

sendButton.addEventListener('click', function () {
    var message = document.getElementById('yourMessage').value;
    document.getElementById('messages').textContent += message + '\n';
    peer.send(yourMessage);
});

