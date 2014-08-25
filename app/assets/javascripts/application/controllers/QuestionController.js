angular.module('chatApp').controller('QuestionController', function ($scope, $location, question, nextQuestion) {
  $scope.question = question;

  $scope.buttonClick = function(option){
    if(option.conditional === 0){
      if(angular.isDefined(nextQuestion)){
        $location.path('/q/' + nextQuestion.id);
      }else{
        $location.path('/complete');
      }
    }else if(option.conditional === 1){
      $location.path('/q/' + option.conditional_question_id);
    }else if(option.conditional === 2){
      $location.path('/complete');
    }
  };
});