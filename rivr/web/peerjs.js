var db = firebase.firestore();
var peer;
var stream;
window.AudioContext = (window.AudioContext || window.webkitAudioContext);
var num = 0;

function startPeer(){
    peer = new Peer();

    peer.on('open', function(id) {
        returnPeerID(id);
    });

    peer.on('connection', function(conn) {
        console.log("Peer: onConnection", "You connected to another peer", conn.peer);
        handleConnection(conn);
        var call = peer.call(conn.peer, stream);
        handleCall(call);
    });

    peer.on('call', function(call) {
        console.log("Peer: onCalled", "You are being called by another peer");
        call.answer(stream);
        handleCall(call);
    });
}


function getPermission(id){
    navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true
    }).then(function(mediaStream){
        onPermissionResult(true);
        audioMeter(mediaStream, id);

        stream = mediaStream;
    }).catch(function(err){
        onPermissionResult(false);
        console.log("ERROR: " + err);
    });
}

function audioMeter(mediaStream, id){
    var audioContext = new AudioContext();
    var mediaStreamSource = audioContext.createMediaStreamSource(mediaStream);
    var processor = audioContext.createScriptProcessor(2048, 1, 1);

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
        if(percentage > num){
            num = percentage;
            console.log(num);
        }
        returnStream(id, mediaStream, percentage);
    };
}


function connectNewUser(otherId){
    console.log("Connecting new user!!", otherId);
    var conn = peer.connect(otherId);
    handleConnection(conn);
}


function handleConnection(conn){
    conn.on('open', function(){
        console.log("Peer: onConnection - conn: onOpen", conn.peer);

        var message = "hi!";
        conn.send(message);
    });
    conn.on('data', function(data){
        console.log('Peer: onConnection - conn: onData', conn.peer, data);
    });
}
function handleCall(call){
    call.on('stream', function(remoteStream) {
        console.log("video streaming..");
        audioMeter(remoteStream, call.peer);
    });
}
