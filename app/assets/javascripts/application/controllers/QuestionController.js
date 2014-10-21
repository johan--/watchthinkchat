angular.module('chatApp').controller('QuestionController', function ($scope, jumpTo, question, nextQuestion, api) {
  $scope.question = question;

  $scope.buttonClick = function(option){
    api.interaction({
      interaction: {
        resource_id: question.id,
        resource_type: question.resource_type,
        action: 'click'
      }
    });
    jumpTo.jump(option, nextQuestion);
  };
});