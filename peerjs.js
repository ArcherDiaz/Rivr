var meterElement = document.getElementById('meter');
var clearRoomButton = document.getElementById('clear');
clearRoomButton.addEventListener('click', function(){
    db.collection("FakeZoom").doc("room303").set({}, {merge: false}).then(function (){
        console.log("Document Uodated:", "cleared!!");
    }).catch((error) => {
        console.log("Error getting document:", error);
    });
});

var db = firebase.firestore();
var peer = new Peer();
var stream;
window.AudioContext = (window.AudioContext || window.webkitAudioContext);
getPermission();


peer.on('open', function(id) {
    var username = "test";
    document.getElementById('yourId').value = id;
    getOtherusers(id);
    
    db.collection("FakeZoom").doc("room303").set({
        users: firebase.firestore.FieldValue.arrayUnion({id: id, username: username})
    }, {merge: true}).then(function (){
        console.log("Document Updated:", "with your ID!!");
    }).catch((error) => {
        console.log("Error getting document:", error);
    });
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



function getPermission(){
    navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true
    }).then(function(mediaStream){
        stream = mediaStream;
        audioMeter(stream);
        var video = document.getElementById('mine');
        if (typeof(mediaView) == 'undefined' || mediaView == null){
            // Does not exist.
            video = document.createElement('video');
            video.id = "mine";
            video.style.width = '50%';
            video.volume = 0.0;
            document.body.appendChild(video);
            if('srcObject' in video) {
                video.srcObject = stream;
            } else {
                video.src = window.URL.createObjectURL(stream); // for older browsers
            }
            video.play();
        }
    })
    .catch(function(err){
        console.log("ERROR: " + err);
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

function startSession(call){
    call.on('stream', function(remoteStream) { // Show stream in some video/canvas element.
        console.log("video streaming..");
        var mediaView =  document.getElementById(call.peer);
        if (typeof(mediaView) == 'undefined' || mediaView == null){
            // Does not exist.
            mediaView = document.createElement('video');
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



function getOtherusers(myID){
    db.collection("FakeZoom").doc("room303").get().then((doc) => {
        console.log("Current data: ", doc.data());
        doc.data().users.forEach(function(value){
            if(value["id"] != myID){
                connectOther(value["id"]);
            }
        });
    });
}
function connectOther(otherId){
    console.log("Connecting new user!!", otherId);
    var conn = peer.connect(otherId);
    conn.on('open', function(){
        console.log("Connection to new user successful!!", otherId);

        var message = "hi!";
        conn.send(message);
        document.getElementById('messages').textContent += message + '\n';
    });
    conn.on('data', function(data){
        console.log('Recieved data from other user!!', otherId, data);
        document.getElementById('messages').textContent += data + '\n';
    });
}
