#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require select2
$('.select2').select2()
if location.hash != ''
    $('a[href="'+location.hash+'"]').tab('show')

$('a[data-toggle="tab"]').on 'click', (e) ->
    location.hash = $(e.target).attr('href').substr(1)