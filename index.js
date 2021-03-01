var peer;
window.AudioContext = (window.AudioContext || window.webkitAudioContext);

document.getElementById('init').addEventListener('click', function () {
    getPermission(true);
});
document.getElementById('listen').addEventListener('click', function () {
    getPermission(false);
});

document.getElementById('connect').addEventListener('click', function () {
    var otherId = JSON.parse(document.getElementById('otherId').value);
    peer.signal(otherId);
});

document.getElementById('send').addEventListener('click', function () {
    var yourMessage = document.getElementById('yourMessage').value;
    document.getElementById('messages').textContent += yourMessage + '\n';
    peer.send(yourMessage);
});

/*
    in firestore there will be a document containing a list of each user in the group call
    each user will be hashmap(so a list of hashmaps). example: 
    {
        "peer ID": "",
        "user name": "",
        "date joined": "",
        "initiator": true,
    }

    uhmm.. so you'd listen to this firestore document...
    when a new user is added to the group,
    then we will create a new peer to connect to for each user we are not already connected to
*/


function getPermission(flag){
    navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true
    }).then(function(stream){
        audioMeter(stream);
        startSession(stream, flag);
    })
    .catch(function(err){
        console.log("ERROR: " + err);
    });
}


function startSession (stream, flag){
    peer = new SimplePeer({
        initiator: flag,
        trickle: false,
        stream: stream
    });

    peer.on('error', err => console.log('error', err));

    peer.on('signal', function (data) {
        console.log("Your device is ready to peer");
        document.getElementById('yourId').value = JSON.stringify(data);
    });

    peer.on('connect', function () {
        console.log("Successfully connected to another peer");
    });

    peer.on('data', function (data) {
        console.log("Data recieved from another peer");
        document.getElementById('messages').textContent += data + '\n';
    });

    peer.on('track', function (track, stream) {
        console.log("audio streaming..");
    });

    peer.on('stream', function (stream) {
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
    });
}

function audioMeter(stream){
    var audioContext = new AudioContext();
    var mediaStreamSource = audioContext.createMediaStreamSource(stream);
    var processor = audioContext.createScriptProcessor(2048, 1, 1);

    mediaStreamSource.connect(audioContext.destination);
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
        var meterElement = document.getElementById('meter');
        meterElement.style.width = percentage + '%';
    };
}
