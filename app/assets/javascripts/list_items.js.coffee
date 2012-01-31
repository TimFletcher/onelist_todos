# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

key =
  up: 38
  down: 40
  enter: 13
  del: 8

disableTextarea = ->
  $('#textarea-wrapper div').addClass('waiting').find('textarea').attr('readonly', 'readonly')

enableTextarea = ->
  $('#textarea-wrapper div').removeClass('waiting').find('textarea').removeAttr('readonly')

focusNewItem = ->
  $('#list_item_text').focus()

# Toggle classes on checkbox clicks
$('.checkoff').live 'click', ->
  c = $(@).closest('.list_item_container')
  if c.hasClass('checked_off') then c.removeClass('checked_off') else c.addClass('checked_off')

# Automatically expand list item textareas on page load
$('#todo-item-list textarea').autoResize(
  animate: false,
  extraSpace : 0
).trigger('change')

# Highlight list item on focus
$('#todo-item-list textarea').live 'focus', ->
  $(this).parent().addClass('focus')
.live 'blur', ->
  $(this).parent().removeClass('focus')

# Save item when:
#  - It loses focus
#  - The user hits enter
#  - The user hits the up/down cursor key

$('#todo-item-list textarea:odd').live 'keydown', (e) ->
  form = $(@).parent()
  switch getKey(e)
    when key.up
      elem = form.parent().prev().find('textarea:eq(1)')
      elem.focus().putCursorAtEnd() if elem.length
      return false
    when key.down, key.enter
      elem = form.parent().next().find('textarea:eq(1)')
      if elem.length then elem.focus().putCursorAtEnd() else focusNewItem()
      return false
    when key.del
      if e.metaKey
        form.next().find('.delete').click()
        elem = form.parent().next().find('textarea:eq(1)')
        if elem.length
          elem.focus().putCursorAtEnd()
        else
          elem = form.parent().prev().find('textarea:eq(1)')
          if elem.length then elem.focus().putCursorAtEnd() else focusNewItem()
        return false
  return true

# Delete an item if it's changed and blank otherwise save
updateHandler = (textarea) ->
  textarea = $(textarea)
  form = textarea.parent()
  if textarea.val().trim().length then form.submit() else form.next().submit()

# Trigger Rails's UJS Ajax if there's a value
submissionHandler = (form, textarea) ->
  form.trigger("submit.rails") unless textarea.val().trim() == ""
  textarea.focus()
  return false

# Keypress browser compatibility
getKey = (e) ->
  return if e.keyCode then e.keyCode else e.which

# Add a new list item if the submit button is clicked or if the enter key is
# pressed from within the input textarea.
addNewItemInit = ->
  form = $('#new_list_item')
  textarea = form.find('#list_item_text')
  textarea.focus()

  # Abort submission if no content when submitting by pressing enter
  textarea.keydown (e) ->
      return submissionHandler(form, textarea) if getKey(e) == key.enter

  # Abort submission if no content when submitting by clicking the button
  form.submit ->
      return submissionHandler(form, textarea)


$(document).ready ->

  addNewItemInit()

  # Bind handlers to events for adding of new items
  $('#new_list_item')
    .bind 'ajax:beforeSend', (evt, xhr, settings) ->
      disableTextarea()
    .bind 'ajax:success', (evt, data, status, xhr) ->
      $.noop
    .bind 'ajax:error', (evt, xhr, status, error) ->
      $.noop
    .bind 'ajax:complete', (evt, xhr, status) ->
      enableTextarea()

  # Bind handlers to events for deleting items
  # $('.delete')
  #   .bind 'ajax:beforeSend', (evt, xhr, settings) ->
  #     $.noop
  #   .bind 'ajax:success', (evt, data, status, xhr) ->
  #     $.noop
  #   .bind 'ajax:error', (evt, xhr, status, error) ->
  #     $.noop
  #   .bind 'ajax:complete', (evt, xhr, status) ->
  #     $.noop

  # Save list title and focus input form on hitting enter
  inputs = $('#edit_list_mobile > input, .edit_list > input')
  inputs.bind 'keydown', (e) ->
    if getKey(e) is key.enter
      $('#list_item_text').focus()
      return false # The focused input gets a line break without this?
  inputs.bind 'blur', (e) -> $(@).parent().submit()

  # Focus last list item if up arrow pressed in the add textarea
  $('#list_item_text').focus().keydown (e) ->
    if getKey(e) is key.up
      elem = $(@).parents('#todo-list-container').find('#todo-item-list > div:last-child .list_item textarea:last-child')
      if elem.length
        elem.each -> $(@).focus().putCursorAtEnd()
      # return false 

  # Delete an item if it's changed otherwise save the change
  $('#todo-item-list textarea:odd').bind 'change', -> updateHandler(@)
