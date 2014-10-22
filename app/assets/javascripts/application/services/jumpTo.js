angular.module('chatApp')
    .service('jumpTo', function ($rootScope, $location) {
      this.jump = function (option, nextQuestion) {
        switch (option.conditional) {
          case 'next':
            if(angular.isDefined(nextQuestion)){
              $location.path('/q/' + nextQuestion.code);
            }else{
              if($rootScope.campaign.share.enabled){
                $location.path('/pair');
              }else{
                $location.path('/complete');
              }
            }
            break;
          case 'skip':
            $location.path('/q/' + option.conditional_question_id);
            break;
          case 'finish':
              if($rootScope.campaign.share.enabled){
                $location.path('/pair');
              }else{
                $location.path('/complete');
              }
            break;
        }
      };
    });
