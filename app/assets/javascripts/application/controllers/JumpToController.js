angular.module('chatApp').controller('JumpToController', function ($scope, $rootScope, jumpTo, option) {

  var findNextQuestion = function(){
    var questionIndex, nextQuestion;
    angular.forEach($rootScope.campaign.survey.questions, function(q, k){
      if(_.contains(q.options, option)){
        questionIndex = k;
      }
    });
    if(angular.isDefined(questionIndex)){
      nextQuestion = $rootScope.campaign.survey.questions[questionIndex + 1];
    }
    return nextQuestion;
  };

  jumpTo.jump(option, findNextQuestion());
});