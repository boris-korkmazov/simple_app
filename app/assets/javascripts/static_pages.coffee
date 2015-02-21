# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  micropost_text = $('#micropost_content')
  micropost_length = 0
  $('#count_chars').text(140)
  micropost_text.on "focus", ->
    $(this).on 'keydown', (event)->
      micropost_length = $(this).val().length
      if micropost_length == 140 && event.keyCode != 8
        event.preventDefault()
      $(this).on 'keyup', (event)->
        micropost_length = $(this).val().length
        $('#count_chars').text((140 - micropost_length).toString())
        $('#count_chars').css({color:""})
        if micropost_length == 140
          $('#count_chars').css({color:"red"})

  micropost_text.on 'blur', ->
    $(this).off 'keydown'
    $(this).off 'keyup' 