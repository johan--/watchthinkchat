angular.module('chatApp')
  .service('visitorActivity', function ($http, $rootScope) {
    var messageQueue = [];
    var processingQueue = false;

    this.queueMessage = function (message, message_type) {
      if ($rootScope.chat_uid === 'offline' || !angular.isDefined($rootScope.chat_uid)) {
        return;
      }
      if (message_type) {
      } else {
        message_type = 'activity';
      }

      messageQueue.push({
        chat_uid: $rootScope.chat_uid,
        visitor_uid: $rootScope.visitor_data.uid,
        message_type: message_type,
        message: message
      });
      if (!processingQueue) {
        postMessage();
      }
    };

    var postMessage = function () {
      if (messageQueue.length === 0) {
        return;
      }
      processingQueue = true;

      var post_data = {
        user_uid: messageQueue[0].visitor_uid,
        message_type: messageQueue[0].message_type,
        message: messageQueue[0].message
      };
      $http.post('/api/chats/' + messageQueue[0].chat_uid + '/messages', post_data).then(function () {
        messageQueue.splice(0, 1);
        processingQueue = false;
        postMessage();
      });
    };
  });