var db = firebase.firestore();
var peer;
var stream;
window.AudioContext = (window.AudioContext || window.webkitAudioContext);
var num = 0;
var connections = new Map();
startPeer();

function startPeer(){
    peer = new Peer({
        secure: true,
        key: "peerjs",
        host: 'rivr-peerjs-server.herokuapp.com',
    });

    peer.on('open', function(id) {
        getPermission(id);
        getOtherUsers(id);
    });

    peer.on('connection', function(conn) {
        var call = peer.call(conn.peer, stream);
        handleConnection(conn);
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
        audioMeter(mediaStream, id);
        stream = mediaStream;

    }).catch(function(err){
        console.log("ERROR: " + err);
    });
}

function shareScreen(elementID){
    navigator.mediaDevices.getDisplayMedia({
        video: {
            cursor: "always",
        },
        audio: false,
    }).then(function(screenStream){
        screenStream.getVideoTracks()[0].addEventListener("ended", function(event){
            updatePeerStream(elementID, stream);
        });
        updatePeerStream(elementID, screenStream);

    }).catch(function(err){
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
            //console.log(num);
        }
        returnStream(id, mediaStream, percentage);
    };

    mediaStream.getVideoTracks()[0].addEventListener("mute", function(event){
        console.log("stream video muted", id, event);
        connections.get(id)["data"].send("ping!");
    });
    mediaStream.getAudioTracks()[0].addEventListener("mute", function(event){
        console.log("stream audio muted", id, event);
        connections.get(id)["data"].send("ping!");
    });
}


function connectNewUser(otherId){
    console.log("Connecting new user!!", otherId);
    var conn = peer.connect(otherId);
    handleConnection(conn);
}

function handleConnection(conn){
    conn.on('open', function(){
        console.log("Peer: onConnection - conn: onOpen", conn.peer);
        if(connections.has(conn.peer)){
            connections.get(conn.peer)["data"] = conn;
        }else{
            connections.set(conn.peer, {
                "data" : conn,
            });
        }
    });
    conn.on('data', function(data){
        console.log('Peer: onConnection - conn: onData', conn.peer, data);
        returnData(data);
    });
    conn.on('error', function(err){
        console.log('Peer: onConnection - conn: onError', conn.peer, err);
    });
}
function handleCall(call){
    if(connections.has(call.peer)){
        connections.get(call.peer)["media"] = call;
    }else{
        connections.set(call.peer, {
            "media" : call,
        });
    }
    call.on('stream', function(remoteStream) {
        console.log("video streaming..");
        audioMeter(remoteStream, call.peer);
    });
    call.on('error', function(err){
        console.log('video streaming: onError', call.peer, err);
    });
}

function hangUp() {
    connections.forEach(function(value, key, map) {
        value["data"].close();
    });
    peer.destroy();
}


function muteMyVideo(flag){
    if(stream != null && stream.getVideoTracks().length > 0){
        stream.getVideoTracks()[0].enabled = flag;
    }
}
function muteMyAudio(flag){
    if(stream != null && stream.getAudioTracks().length > 0){
        stream.getAudioTracks()[0].enabled = flag;
    }
}


//THIS FUNCTION WILL UPDATE THE CURRENT STREAM BEING SENT TO ALL OF ITS PEERS
function updatePeerStream(elementID, newStream){
    connections.forEach(function(value, key, map) { //for each connection I currently have
        value["media"].peerConnection.getSenders().forEach(function(sender){ //get the media senders of the connection
            if(sender.track.kind == "video" && newStream.getVideoTracks().length > 0){
                sender.replaceTrack(newStream.getVideoTracks()[0]); //update the media sender with the new media
            }
        });
    });
    //now update the video element's stream
    var video = document.getElementById(elementID);
    if (typeof(video) != 'undefined' && video != null){
        if('srcObject' in video) {
            video.srcObject = newStream;
        } else {
            video.src = window.URL.createObjectURL(newStream); // for older browsers
        }
        video.play();
    }
}

//THIS FUNCTION WILL SEND OUT A MESSAGE TO ALL PEERS
function sendData(data){
    connections.forEach(function(value, key, map) {
        value["data"].send(data);
    });
}

//PASS IN THE ID OF THE VIDEO WHOSE VOLUME YOU WANT TO CHANGE
function volumeMeter(videoID, volume){
    var video = document.getElementById(videoID);
    video.volume = volume;
}



function getOtherUsers(myID){
    db.collection("FakeZoom").doc("meh").set({
        users: firebase.firestore.FieldValue.arrayUnion({
            "peer ID": myID,
            "user ID": "",
            "username": "",
            "photo URL": "",
        })
    }, {merge: true}).then(function (){
        console.log("Document Updated:", "with your ID!!");
    }).catch((error) => {
        console.log("Error getting document:", error);
    });

    db.collection("FakeZoom").doc("meh").get().then((doc) => {
        console.log("Current data: ", doc.data());

        doc.data().users.forEach(function(value){
            if(value["peer ID"] != myID){
                connectNewUser(value["peer ID"]);
            }
        });

    });
}

function returnStream(elementID, mediaStream, percentage){
    var video = document.getElementById(elementID);
    if (typeof(video) == 'undefined' || video == null){
        // Does not exist.
        video = document.createElement('video');
        video.id = elementID;
        video.style.width = '50%';
        video.style.border = percentage + "px solid #0000FF";
        video.volume = 0.0;
        document.body.appendChild(video);
        if('srcObject' in video) {
            video.srcObject = mediaStream;
        } else {
            video.src = window.URL.createObjectURL(mediaStream); // for older browsers
        }
        video.play();
    }else{
        video.style.border = percentage + "px solid #0000FF";
    }

    video.addEventListener("ended", function(){
        console.log("ended!!", elementID);
    });
}

document.getElementById('share').addEventListener('click', function(){
    shareScreen(peer.id);
});

document.getElementById('send').addEventListener('click', function(){
    var msg = peer.id + ": " + document.getElementById('yourMessage').value;
    sendData(msg);
});

document.getElementById('video').addEventListener('click', function(){
    muteMyVideo(!stream.getVideoTracks()[0].enabled);
});

document.getElementById('audio').addEventListener('click', function(){
    muteMyAudio(!stream.getAudioTracks()[0].enabled);
});

document.getElementById('clear').addEventListener('click', function(){
    db.collection("FakeZoom").doc("meh").set({}, {merge: false}).then(function (){
        console.log("Document Updated:", "cleared!!");
    }).catch((error) => {
        console.log("Error getting document:", error);
    });
});
