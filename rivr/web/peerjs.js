var peer;
var stream;
window.AudioContext = (window.AudioContext || window.webkitAudioContext);
var connections = new Map();

function startPeer(){
    peer = new Peer({
        secure: true,
        key: "peerjs",
        host: 'rivrpeer.glitch.me',
        path: "/",
    });
    peer.on('open', function(id) {
        returnPeerID(id);
    });
    peer.on('connection', function(conn) {
        var call = peer.call(conn.peer, stream);
        handleConnection(conn);
        handleCall(call);
    });
    peer.on('call', function(call) {
        console.log("Peer: onCall", "You are being called by another peer");
        call.answer(stream);
        handleCall(call);
    });
    peer.on('close', function() {
        console.log("Peer: onClose");
    });
}

function getPermission(id, gettingPermission, facingMode){
    navigator.mediaDevices.getUserMedia({
        video: {
           facingMode: facingMode,
        },
        audio: true,
    }).then(function(mediaStream){
        if(gettingPermission == true){
            returnPermissionResult(true);
            audioMeter(mediaStream, id);
        }
        stream = mediaStream;
        if(gettingPermission == false){
            //if the user is simply switching their camera OR
            //if there are any users connected to us, update their stream of us to this new one
            updatePeerStream(id, mediaStream);
        }
    }).catch(function(err){
        if(gettingPermission == true){
            returnPermissionResult(false);
        }
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
            onScreenShareClosed();
        });
        updatePeerStream(elementID, screenStream);

    }).catch(function(err){
          onScreenShareClosed();
          console.log("ERROR: " + err);
      });
}

function audioMeter(mediaStream, id){
    let audioContext = new AudioContext();
    let analyzer = audioContext.createAnalyser();
    analyzer.fftSize = 32;
    let mediaStreamSource = audioContext.createMediaStreamSource(mediaStream);
    mediaStreamSource.connect(analyzer);
    //analyzer.connect(audioContext.destination);
    let data = new Uint8Array(analyzer.frequencyBinCount);

    let loopingFunction = function(){
        requestAnimationFrame(loopingFunction);
        analyzer.getByteFrequencyData(data);
        let total = 0;

        for(var i = 0; i < data.length; i++) {
            total = total + data[i];
        }
        let average = total / data.length;
        let percentage = average / (255 / 100);
        console.log(percentage);
        if(peer.destroyed == false &&  peer.disconnected == false){
            returnStream(id, mediaStream, percentage);
        }
    };
    loopingFunction();
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
    conn.on('close', function(){
        console.log('Peer: onConnection - conn: onClose', conn.peer);
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
        console.log("video stream: onStream..");
        audioMeter(remoteStream, call.peer);
    });
    call.on('close', function(){
        console.log('Peer: onCall - stream: onClose', call.peer);
    });
    call.on('error', function(err){
        console.log('Peer: onCall - stream: onError', call.peer, err);
    });
}

function leaveCall(){
    connections.forEach(function(value, key, map) {
        //for each connected peer/user, close both the data and media connection between us
        if (typeof(value["data"]) != 'undefined' && value["data"] != null){
            value["data"].close();
        }
        if (typeof(value["media"]) != 'undefined' && value["media"] != null){
            value["media"].close();
        }

    });
    //destroy the peer object itself
    peer.destroy();
    connections.clear();
    stream.getTracks().forEach(function(track) {
        //for each media track in our own stream (audio and video), stop them
        track.stop();
    });
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
        if (typeof(value["data"]) != 'undefined' && value["data"] != null){
            value["data"].send(data);
        }
    });
}

//PASS IN THE ID OF THE VIDEO WHOSE VOLUME YOU WANT TO CHANGE
function volumeMeter(videoID, volume){
    var video = document.getElementById(videoID);
    video.volume = volume;
}
