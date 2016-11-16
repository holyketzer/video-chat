var session;
var connectionCount = 0;
var publisher;

function openTokConnect(apiKey, sessionId, token) {
  // Replace with the replacement element ID:
  publisher = OT.initPublisher('#chat');
  publisher.on({
    streamCreated: function (event) {
      console.log("Publisher started streaming.");
    },
    streamDestroyed: function (event) {
      console.log("Publisher stopped streaming. Reason: "
        + event.reason);
    }
  });

  session = OT.initSession(apiKey, sessionId);
  session.on({
    connectionCreated: function (event) {
      connectionCount++;
      console.log(connectionCount + ' connections.');
    },
    connectionDestroyed: function (event) {
      connectionCount--;
      console.log(connectionCount + ' connections.');
    },
    sessionDisconnected: function sessionDisconnectHandler(event) {
      // The event is defined by the SessionDisconnectEvent class
      console.log('Disconnected from the session.');
      document.getElementById('disconnectBtn').style.display = 'none';
      if (event.reason == 'networkDisconnected') {
        alert('Your network connection terminated.')
      }
    },
    streamCreated: function(event) {
      session.subscribe(event.stream);
    }
  });

  // Replace token with your own value:
  session.connect(token, function(error) {
    if (error) {
      console.log('Unable to connect: ', error.message);
    } else {
      document.getElementById('disconnectBtn').style.display = 'block';
      console.log('Connected to the session.');
      connectionCount = 1;

      if (session.capabilities.publish == 1) {
        session.publish(publisher);
      } else {
        console.log("You cannot publish an audio-video stream.");
      }
    }
  });

}

function openTokDisconnect() {
  session.disconnect();
}

$(function() {
  $('.join').click(function() {
    $.ajax({
      url: $(this).data('url'),
      method: 'POST',
      success: function(data, status, jqXHR) {
        openTokConnect(data.api_key, data.session_id, data.token);
      }
    });
  });
});