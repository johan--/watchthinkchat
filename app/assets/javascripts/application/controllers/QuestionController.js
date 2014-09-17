angular.module('chatApp').controller('QuestionController', function ($scope, jumpTo, question, nextQuestion) {
  $scope.question = question;

  $scope.buttonClick = function(option){
    jumpTo.jump(option, nextQuestion);
  };
});