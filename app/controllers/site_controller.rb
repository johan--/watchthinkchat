class SiteController < ApplicationController
  def index
    @campaign = OpenStruct.new(
      name: '#FallingPlates',
      engagement_player: {
        media_link: 'https://www.youtube.com/watch?v=KGlx11BxF24',
        questions: [
          {
            id: 0,
            title: 'Jesus asks you, "Will you follow me?"',
            help_text: '(Click one now)',
            options: [
              {
                id: 0,
                title: 'No thanks',
                code: '98HbZKK',
                conditional: 0
              }, {
                id: 1,
                title: 'I follow another faith',
                code: 'bUbkj56V',
                conditional: 0
              }, {
                id: 2,
                title: 'I am not sure',
                code: 'AklnAK',
                conditional: 0
              }, {
                id: 3,
                title: 'I want to start',
                code: 'PB3ave',
                conditional: 0
              }, {
                id: 4,
                title: 'I\'m trying',
                code: '84rehrB',
                conditional: 0
              }, {
                id: 5,
                title: 'I\'m following Jesus',
                code: 'Nkl397r',
                conditional: 0
              }
            ]
          },
        ]
      }
    )
  end
end
