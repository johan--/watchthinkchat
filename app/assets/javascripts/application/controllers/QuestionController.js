angular.module('chatApp').controller('QuestionController', function ($scope, $location, question, nextQuestion) {
  $scope.question = question;

  $scope.buttonClick = function(option){
    switch (option.conditional) {
      case 0:
        if(angular.isDefined(nextQuestion)){
          $location.path('/q/' + nextQuestion.id);
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