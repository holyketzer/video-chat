var session;
var connectionCount = 0;
var publisher;

function openTokConnect(apiKey, sessionId, token) {
  // Replace with the replacement element ID:
  publisher = OT.initPublisher(
    document.getElementById('chat'), {
      fitMode: 'contain',
      insertMode: 'append',
      insertDefaultUI: true,
      showControls: true,
      width: '400px',
      height: '360px'
    }
  );

  publisher.on({
    streamCreated: function (event) {
      console.log('Publisher started streaming.');
    },
    streamDestroyed: function (event) {
      console.log('Publisher stopped streaming. Reason: '
        + event.reason);
    }
  });

  function swith_connected_ui(connected) {
    if (connected) {
      $('.connect').hide();
      $('.disconnect').show();
    } else {
      $('.connect').show();
      $('.disconnect').hide();
    }
  };

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
      swith_connected_ui(false);
      if (event.reason == 'networkDisconnected') {
        alert('Your network connection terminated.')
      }
    },
    streamCreated: function(event) {
      session.subscribe(event.stream, 'chat', {
        insertMode: 'append',
        width: '400px',
        height: '360px'
      });
    }
  });

  // Replace token with your own value:
  session.connect(token, function(error) {
    if (error) {
      console.log('Unable to connect: ', error.message);
    } else {
      console.log('Connected to the session.');
      swith_connected_ui(true);
      connectionCount = 1;

      if (session.capabilities.publish == 1) {
        session.publish(publisher);
      } else {
        console.log('You cannot publish an audio-video stream.');
      }
    }
  });
}

function openTokDisconnect() {
  session.disconnect();
}

$(function() {
  $('.connect').click(function() {
    $.ajax({
      url: $(this).data('url'),
      method: 'POST',
      success: function(data, status, jqXHR) {
        openTokConnect(data.api_key, data.session_id, data.token);
      }
    });
  });

  $('.disconnect').click(function() {
    openTokDisconnect();
  });
});