angular.module('chatApp')
    .service('jumpTo', function ($location) {
      this.jump = function (option, nextQuestion) {
        switch (option.conditional) {
          case 'next':
            if(angular.isDefined(nextQuestion)){
              $location.path('/q/' + nextQuestion.code);
            }else{
              $location.path('/complete');
            }
            break;
          case 'skip':
            $location.path('/q/' + option.conditional_question_id);
            break;
          case 'finish':
            $location.path('/complete');
            break;
        }
      };
    });
