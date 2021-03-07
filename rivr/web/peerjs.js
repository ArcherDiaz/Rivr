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
        console.log("Peer: onConnection", "You connected to another peer");
        var call = peer.call(conn.peer, stream);
        startSession(call);

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
        console.log("Peer: onCalled", "You are being called by another peer");
        call.answer(stream);
        startSession(call);
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




function addMyData(){
    var userID = "test";
    var username = "test";
    var userPhotoURL = "test";

    db.collection("FakeZoom").doc("room303").set({
        users: firebase.firestore.FieldValue.arrayUnion({
            "peer ID": id,
            "user ID": userID,
            "username": username,
            "photo URL": userPhotoURL
        })
    }, {merge: true}).then(function (){
        console.log("Document Updated:", "with your ID!!");
    }).catch((error) => {
        console.log("Error getting document:", error);
    });
}
function getOtherUsers(myID){
    db.collection("FakeZoom").doc("room303").get().then((doc) => {
        console.log("Current data: ", doc.data());

        doc.data().users.forEach(function(value){
            if(value["peer ID"] != myID){
                connectOtherUser(value["peer ID"]);
            }
        });

    });
}

function connectOtherUser(otherId){
    console.log("Connecting new user!!", otherId);
    var conn = peer.connect(otherId);
    conn.on('open', function(){
        console.log("Connection to new user successful!!", otherId);

        var message = "hi!";
        conn.send(message);
        document.getElementById('messages').textContent += message + '\n';
    });
    conn.on('data', function(data){
        console.log('Received data from other user!!', otherId, data);
        document.getElementById('messages').textContent += data + '\n';
    });
}
function startSession(otherUserCall){
    otherUserCall.on('stream', function(remoteStream) { // Show stream in some video/canvas element.
        console.log("video streaming..");
        var mediaView =  document.getElementById(otherUserCall.peer);
        if (typeof(mediaView) == 'undefined' || mediaView == null){
            // Does not exist.
            mediaView = document.createElement('video');
            mediaView.id = otherUserCall.peer;
            mediaView.style.width = '50%';
            document.body.appendChild(mediaView);
            if('srcObject' in mediaView) {
                mediaView.srcObject = remoteStream;
            } else {
                mediaView.src = window.URL.createObjectURL(remoteStream); // for older browsers
            }
            mediaView.play();
        }
        audioMeter(remoteStream, otherUserCall.peer);
    });
}




function clearRoom(){
    db.collection("FakeZoom").doc("room303").set({}, {merge: false}).then(function (){
        console.log("Document Updated:", "cleared!!");
    }).catch((error) => {
        console.log("Error getting document:", error);
    });
}
