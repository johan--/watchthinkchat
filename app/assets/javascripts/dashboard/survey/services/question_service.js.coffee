app.factory 'Question', ['$resource', ($resource) ->
  class Question
    constructor: () ->
      @service =
        $resource "/campaigns/#{campaign_id}/build/api/questions/:id",
          { id: '@id' },
          { update: { method: 'PUT' } }

    create: (attrs) ->
      new @service(question: attrs).$save (question) ->
        attrs.id = question.id
      attrs

    all: ->
      @service.query()
]

