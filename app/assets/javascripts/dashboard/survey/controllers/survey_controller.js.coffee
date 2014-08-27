app.controller 'SurveyController', [ '$scope', 'Question', ($scope, Question) ->
  $scope.question_attributes = { }

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

  $scope.updateQuestion = (question) ->
    question.$update()
    $scope.active_question = null

  $scope.toggleQuestion = (question) ->
    if $scope.active_question == question
      $scope.active_question = null
    else
      $scope.active_question = question

  $scope.addOptionToQuestion = (question) ->
    question.options_attributes ||= []
    question.options_attributes.
    push({
      title: "Option #{question.options_attributes.length + 1}",
      flow: 'next'
    })

  $scope.removeOptionFromQuestion = (question, option) ->
    if option.id
      option._destroy = '1'
    else
      question.options_attributes.
      splice question.options_attributes.indexOf(option), 1

  $scope.addOptionToNew = ->
    $scope.question_attributes.options_attributes ||= []
    $scope.question_attributes.options_attributes.
    push({
      title: "Option #{$scope.question_attributes.options_attributes.length + 1}",
      flow: 'next'
    })

  $scope.removeOptionFromNew = (option) ->
    $scope.question_attributes.options_attributes.
    splice $scope.question_attributes.options_attributes.indexOf(option), 1


  $scope.questionSortable = {
    update: (e, ui) ->
      console.log ui.item.index()
    axis: 'y'
    handle: '.draghandle_disabled'
  }
]