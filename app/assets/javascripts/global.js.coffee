$.ajaxSetup
  error: (jqXHR, textStatus, errorThrown) ->
    content  = '<ul id="flash-messages">\n'
    content += '  <li class="message-error">'
    if textStatus == 'timeout'
      content += 'The connection timed out. Is your Internet connection ok?'
    else
      content += 'The server returned an error. We\'re looking into it.'
    content += '</li>\n'
    content += '</ul>'
    $(content).appendTo('header').delay(2500).fadeOut 300
    enableTextarea()

$(document).ready ->
  
  # Prevent links from opening in Safari when running in app mode on iPhone
  $('a').live 'click', (e) ->
    e.preventDefault;
    window.location = $(@).attr("href")
    false

  # Flash Messages
  $('#flash-messages').delay(2500).fadeOut(300)

  navElements = $('#header-nav a, #header-nav form')

  # Show/Hide navigation
  $('#toggle-nav').click ->
    if navElements.is(':visible') then navElements.hide() else navElements.css('display', 'block')

  # Hide navigation on a click away
  $(document).bind 'click', (e) ->
    clicked = $(e.target)
    if not clicked.parents().hasClass 'header-nav'
      navElements.hide()

  # Always focus first form input
  $('.input input:first').focus()

  # Form inputs and their inset labels
  $(".input input").each ->

    # Fade out labels on input focus
    $(@).focus ->
      $(@).parents('.input').find('label').addClass("focus")

    # Hide label if key pressed in input
    $(@).keypress ->
      $(@).parents('.input').find('label').addClass("has-text").removeClass("focus")

    # Show label if input unfocused without content
    $(@).blur ->
      if $(@).val() == ""
        $(@).parents('.input').find('label').removeClass("has-text").removeClass("focus")

    # Hide labels on load if inputs have content
    if $(@).val()
      $(@).parents('.input').find('label').addClass('has-text')

#   $('#list_name').focus().putCursorAtEnd()
# 
#   Save form and leave edit state on hitting enter
#   $('#lists form > input').live 'keydown', (e) ->
#     input = $(@)
#     form = input.parent()
#     form.bind 'submit', ->
#       list_link = form.find('.name');
#       list_link.html(input.val()).show();
#       input.hide()
# 
#   Toggle edit state via edit button
#   $('.edit').live 'click', (e) ->
#     id = $(@).data('id')
#     form = $ "#list_#{id}"
#     input = form.find("#list_name_#{id}")
#     list_link = form.find('.name');
#     if list_link.is(':visible')
#       list_link.hide()
#       input.show().focus().putCursorAtEnd()
#     else
#       list_link.html(input.val()).show();
#       input.hide()
#     return false