angular.module('chatApp')
    .service('jumpTo', function ($location) {
      this.jump = function (option, nextQuestion) {
        switch (option.conditional) {
          case 0:
            if(angular.isDefined(nextQuestion)){
              $location.path('/q/' + nextQuestion.code);
            }else{
              $location.path('/complete');
            }
            break;
          case 1:
            $location.path('/q/' + option.conditional_question_id);
            break;
          case 2:
            $location.path('/complete');
            break;
        }
      };
    });
