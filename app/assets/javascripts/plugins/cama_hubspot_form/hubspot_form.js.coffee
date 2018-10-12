$(document).ready ->
  $('select.has_dependents').on 'change', ->
    option = $('option:selected', this).val()
    id = $(this).attr('id')
    $.each $('.' + id), (key, value) ->
      $(this).hide()
      str_value = $(this).attr('data-strValue')
      condition = $(this).attr('data-condition')
      keys = str_value.split('###')
      if condition == 'IS_NOT_EMPTY'
        if option
          $(this).show()
      else if condition == 'SET_ANY'
        if $.inArray(option, keys) != -1 or str_value == ''
          $(this).show()
  
  $('input.has_dependents, textarea.has_dependents').on 'keyup', ->
    input_value = $(this).val()
    id = $(this).attr('id')
    $.each $('.' + id), (key, value) ->
      $(this).hide()
      condition = $(this).attr('data-condition')
      if condition == 'IS_NOT_EMPTY'
        if input_value
          $(this).show()