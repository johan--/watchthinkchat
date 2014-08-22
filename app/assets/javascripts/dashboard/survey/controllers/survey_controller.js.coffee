app.controller 'SurveyController', [ '$scope', 'Question', ($scope, Question) ->
  $scope.question_attributes = { options: [] }

  $scope.init = ->
    @questionService = new Question()
    $scope.questions = @questionService.all()
    $scope.addOptionToNew()

  $scope.addQuestion = ->
    question = @questionService.create($scope.question_attributes)
    $scope.questions.push(question)
    $scope.question_attributes = { options: [] }
    $scope.addOptionToNew()

  $scope.deleteQuestion = (question) ->
    $scope.questions.splice $scope.questions.indexOf(question), 1
    question.$delete()

  $scope.toggleQuestion = (question) ->
    if $scope.active_question == question
      $scope.active_question = null
    else
      $scope.active_question = question

  $scope.addOptionToNew = ->
    $scope.question_attributes.options.
    push({
      title: "Option #{$scope.question_attributes.options.length + 1}",
      flow: 'next'
    })

  $scope.removeOptionFromNew = (option) ->
    $scope.question_attributes.options.
    splice $scope.question_attributes.options.indexOf(option), 1


  $scope.questionSortable = {
    update: (e, ui) ->
      console.log ui.item.index()
    axis: 'y'
    handle: '.draghandle'
  }
]