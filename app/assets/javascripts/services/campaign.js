angular.module('chatApp')
  .service('campaignResolve', function ($http, $q, $sce) {
    this.getCampaignInfo = function (campaignID) {
      var defer = $q.defer();

      $http({method: 'GET', url: '/api/campaigns/' + campaignID}).
        success(function (data) {
          data.video_start = 0;
          data.video_end = 235;
          data.followup_buttons.push({
            id: 1,
            text: 'No thanks',
            action: 'chat',
            value: '',
            message_active_chat: '<p>You said "No" to following Jesus.</p><h1>That\'s honest!</h1><p>We appreciate the time you gave to watch Falling Plates.Thanks for telling us straight up what you think. There is obviously a reason in your mind right now that causes you to say no to following Jesus. We would love to have a chat about it. If you are interested we can chat about your perspective...</p>',
            message_no_chat: '<p>You said "No" to following Jesus.</p><h1>That\'s honest!</h1><p>Thanks for telling us straight up what you think. We really appreciate the time you gave to watch Falling Plates. There is obviously a reason in your mind right now that causes you to say no to following Jesus. The next best step for you is to really talk to a Christian friend that you know and trust. If you are interested, we will help you find one. Check out the "Growth Challenge"</p>',
            message_growth_challenge: 'It\'s simple and it\'s free! Over the next 4 weeks we’ll email you a new thought-provoking video with discussion questions about a relationship with Jesus.',
            message_friend_title: 'Why involve a Christian friend you know and trust?',
            message_friend: 'To get a genuine look at how your friend follows Jesus. Select someone you know and trust, who has mentioned their faith to you, and is able to listen.',
            message_finished: $sce.trustAsHtml('<p>Thanks for taking the time to watch #Fallingplates today. We hope that the film made a real impact in how you understand God’s love for you. Spiritual growth is a key value to us at Cru. We hope that beyond watching - thinking  and chatting that you can actually grow into all that God would have for you. We pray that signing up for the Growth Challenge today and adding a friend will be transformative! We pray you grow! Go check your email to confirm your subscription.</p><p>God bless your growth.<br>Your friends at Cru<br><a href="http://www.cruoncampus.org" target="_blank">www.cruoncampus.org</a></p>')
          });
          data.followup_buttons.push({
            id: 2,
            text: 'I follow another faith',
            action: 'chat',
            value: '',
            message_active_chat: '<p>You said "I follow another faith"</p><h1>That\'s appreciated!</h1><p>Thanks for taking time to watch #Fallingplates and considering how Jesus desires to bring life to you today. What is it that you find interesting about Jesus? Lets chat about that if you are interested...</p>',
            message_no_chat: '<p>You said "I follow another faith"</p><h1>That\'s appreciated!</h1><p>Thanks for taking time to watch #Fallingplates and considering how Jesus desires to bring life to you today. We would like to help you understand the uniqueness of Jesus and what we believe he has done for you. If you are interested to look into this with one of your Christian friends that you know and trust, let us help you connect with them...You interested? Check out the "Growth Challenge"</p>',
            message_growth_challenge: 'It\'s simple and it\'s free! Over the next 4 weeks we’ll email you a new thought-provoking video with discussion questions about a relationship with Jesus.',
            message_friend_title: 'Why involve a Christian friend you know and trust?',
            message_friend: 'To get a genuine look at how your friend follows Jesus. Select someone you know and trust, who has mentioned their faith to you, and is able to listen.',
            message_finished: $sce.trustAsHtml('<p>Thanks for taking the time to watch #Fallingplates today. We hope that the film made a real impact in how you understand God’s love for you. Spiritual growth is a key value to us at Cru. We hope that beyond watching - thinking  and chatting that you can actually grow into all that God would have for you. We pray that signing up for the Growth Challenge today and adding a friend will be transformative! We pray you grow! Go check your email to confirm your subscription.</p><p>God bless your growth.<br>Your friends at Cru<br><a href="http://www.cruoncampus.org" target="_blank">www.cruoncampus.org</a></p>')
          });
          data.followup_buttons.push({
            id: 3,
            text: 'I am not sure',
            action: 'chat',
            value: '',
            message_active_chat: '<p>You said "I\'m not sure" to following Jesus.<h1>That\'s honest!</h1><p>Thanks for watching #FallingPlates and considering Jesus\'s call to follow Him. We are pumped that you are at least considering following Jesus! What is one thing that is attractive to you in following Jesus? What is one thing that makes you hesitant? We\'d love to chat with you about this stuff in the chat panel...</p>',
            message_no_chat: '<p>You said "I\'m not sure" to following Jesus.<h1>That\'s honest!</h1><p>Thanks for taking time to watch #FallingPlates and for considering Jesus\'s call to follow Him. We are glad that you are at least considering following Jesus. What is one thing that is attractive to you in following Jesus? What is one thing that makes you hesitant? We have a growth challenge that can help you find significance in following Jesus. Check out the "Growth Challenge"</p>',
            message_growth_challenge: 'It\'s simple and it\'s free! Over the next 4 weeks we’ll email you a new thought-provoking video with discussion questions about a relationship with Jesus.',
            message_friend_title: 'Why involve a Christian friend you know and trust?',
            message_friend: 'So you can get some insight from your friend on what it looks like to follow Jesus.',
            message_finished: $sce.trustAsHtml('<p>Thanks for taking the time to watch #Fallingplates today. We hope that the film made a real impact in how you understand God’s love for you. Spiritual growth is a key value to us at Cru. We hope that beyond watching - thinking  and chatting that you can actually grow into all that God would have for you. We pray that signing up for the Growth Challenge today and adding a friend will be transformative! We pray you grow! Go check your email to confirm your subscription.</p><p>God bless your growth.<br>Your friends at Cru<br><a href="http://www.cruoncampus.org" target="_blank">www.cruoncampus.org</a></p>')
          });
          data.followup_buttons.push({
            id: 4,
            text: 'I want to start',
            action: 'chat',
            value: '',
            message_active_chat: '<p>You said "I want to start" following Jesus!</p><h1>That\'s Awesome!</h1><p>Thanks for taking time to watch #FallingPlates and for considering Jesus\'s call to follow Him. To desire to start following Jesus is a significant step! It\'s awesome to see you have that desire! Tell us a bit about what\'s up, what made you want to start? We\'d love to chat with you about this stuff in the chat panel...</p>',
            message_no_chat: '<p>You said "I want to start" following Jesus!</p><h1>That\'s Awesome!</h1><p>Thanks for taking time to watch #FallingPlates and for considering Jesus\'s call to follow Him. To want to start following Jesus is a significant step. It\'s awesome to see you have that desire! We have a growth challenge that can help you grow if you want to start following Christ. Here\'s the best place for you to get connected with a friend to grow... Checkout the "Growth Challenge"</p>',
            message_growth_challenge: 'It\'s simple and it\'s free! Over the next 4 weeks we’ll email you a new thought-provoking video with discussion questions about your relationship with Jesus.',
            message_friend_title: 'Why involve a Christian friend you know and trust?',
            message_friend: 'Following Jesus is meant to happen with others [in community]. Who better to start this with, than a friend you know and trust?',
            message_finished: $sce.trustAsHtml('<p>Thanks for taking the time to watch #Fallingplates today. We hope that the film made a real impact in how you understand God’s love for you. Spiritual growth is a key value to us at Cru. We hope that beyond watching - thinking  and chatting that you can actually grow into all that God would have for you. We pray that signing up for the Growth Challenge today and adding a friend will be transformative! We pray you grow! Go check your email to confirm your subscription.</p><p>God bless your growth.<br>Your friends at Cru<br><a href="http://www.cruoncampus.org" target="_blank">www.cruoncampus.org</a></p>')
          });
          data.followup_buttons.push({
            id: 5,
            text: 'I\'m trying',
            action: 'chat',
            value: '',
            message_active_chat: '<p>You said "I\'m trying" to following Jesus!</p><h1>That\'s honest!</h1><p>Thanks for watching #FallingPlates and taking time to express how you feel about following Jesus. Sometimes we feel like we will never get there, be good enough or be the person God wants us to be...which can leave us feeling disappointed or disillusioned. We\'d love to chat with you about this stuff in the chat panel...</p>',
            message_no_chat: '<p>You said "I\'m trying" to following Jesus!</p><h1>That\'s honest!</h1><p>Thanks for watching #FallingPlates and taking time to express how you feel about following Jesus. Sometimes we feel like we will never get there, be good enough or be the person God wants us to be...which can leave us feeling disappointed or disillusioned. We have a Growth Challenge that can help you find real satisfaction and confidence in following Jesus. It will help you understand that the relationship is based on his efforts which are sufficient  Checkout the "Growth Challenge"</p>',
            message_growth_challenge: 'It\'s simple and it\'s free! Over the next 4 weeks we’ll email you a new thought-provoking video with discussion questions about your relationship with Jesus.',
            message_friend_title: 'Why involve a Christian friend you know and trust?',
            message_friend: 'Following Jesus is meant to happen with others [in community]. Who better to start this with, than a friend you know and trust?',
            message_finished: $sce.trustAsHtml('<p>Thanks for taking the time to watch #Fallingplates today. We hope that the film made a real impact in how you understand God’s love for you. Spiritual growth is a key value to us at Cru. We hope that beyond watching - thinking  and chatting that you can actually grow into all that God would have for you. We pray that signing up for the Growth Challenge today and adding a friend will be transformative! We pray you grow! Go check your email to confirm your subscription.</p><p>God bless your growth.<br>Your friends at Cru<br><a href="http://www.cruoncampus.org" target="_blank">www.cruoncampus.org</a></p>')
          });
          data.followup_buttons.push({
            id: 6,
            text: 'I\'m following Jesus',
            action: 'chat',
            value: '',
            message_active_chat: '<p>You said "I am following Jesus"</p><h1>That\'s Awesome!</h1><p>We are pumped that you are following Jesus! We would love to connect with you and discover how your journey is going and what you think the next steps are to be who He wants you to be? Let\'s chat...</p>',
            message_no_chat: '<p>You said "I am following Jesus"</p><h1>That\'s Awesome!</h1><p>We are pumped that you are following Jesus! We know that its not always an easy path, but it\'s definitely worth it :)  We don\'t know all that\'s going on in your life today, but we are glad He led you here! It\'s our goal to help you grow and to help you have influence. We would love to connect you with someone in the adventure of knowing Jesus. Checkout the "Growth Challenge"</p>',
            message_growth_challenge: 'The best Growth Challenge you can take is impacting one of your friends! Enter your info and over the next four weeks we will email you a new thought-provoking video about how a person can begin following Jesus.',
            message_friend_title: 'What type of friend do I invite?',
            message_friend: 'Then invite one person you want to know Jesus to take this Growth Challenge with you. They\'ll get a link, watch #FallingPlates, and have the chance to accept your invitation.',
            message_finished: $sce.trustAsHtml('<p>Thanks for taking the time to watch #Fallingplates today. We hope that your experience today has been one of excitement in realising you can impact others with your faith. Thanks also for signing up in the growth challenge as a mentor to the friend you invited. Pray that the friend you invited actually comes and signs up to the growth challenge alongside you! The mentor material you get matches the material your friend will be getting. So go check your email to confirm your 4 week subscription and get on with the Growth Challenge with your friend. We pray you grow! </p><p>God bless your growth.<br>Your friends at Cru<br><a href="http://www.cruoncampus.org" target="_blank">www.cruoncampus.org</a></p>')
          });

          defer.resolve(data);
        }).error(function () {
          defer.resolve(null);
        });

      return defer.promise;
    };
  });