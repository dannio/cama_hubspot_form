$(document).ready ->
  $('select.has_dependents').on 'change', ->
    option = $('option:selected', this).val()
    id = $(this).attr('id')
    $.each $('.' + id), (key, value) ->
      $(this).hide()
      str_values = $(this).attr('data-strValues')
      condition = $(this).attr('data-condition')
      keys = str_values.split('###')
      if condition == 'IS_NOT_EMPTY'
        if option
          $(this).show()
      else if condition == 'SET_ANY'
        if $.inArray(option, keys) != -1 or str_values == ''
          $(this).show()
      else if condition == 'SET_NOT_ANY'
        if $.inArray(option, keys) != -1 or str_values == ''
          $(this).hide()
  
  $('input.has_dependents, textarea.has_dependents').on 'keyup', ->
    input_value = $(this).val()
    id = $(this).attr('id')
    $.each $('.' + id), (key, value) ->
      $(this).hide()
      $('input, textarea', this).prop("required", false)
      str_value = $(this).attr('data-strValue')
      condition = $(this).attr('data-condition')
      required  = $(this).attr('data-required')
      if condition == 'IS_NOT_EMPTY'
        if input_value
          $(this).show()
          if required == 'true'
            $('input', this).prop("required", true)
      if condition == 'CONTAINS'
        if input_value.indexOf(str_value) != -1 
          $(this).show()
          if required == 'true'
            $('input', this).prop("required", true)
      if condition == 'DOESNT_CONTAIN'
        if input_value.indexOf(str_value) == -1 
          $(this).show()
          if required == 'true'
            $('input', this).prop("required", true)
      if condition == 'EQ'
        if input_value == str_value
          $(this).show()
          if required == 'true'
            $('input', this).prop("required", true)
      if condition == 'NEQ'
        if input_value != str_value
          $(this).show()
          if required == 'true'
            $('input', this).prop("required", true)
      if condition == 'STR_STARTS_WITH'
        if input_value.indexOf(str_value) == 0
          $(this).show()
          if required == 'true'
            $('input', this).prop("required", true)
      if condition == 'STR_ENDS_WITH'
        if input_value.slice(str_value.length * -1) == str_value
          $(this).show()
          if required == 'true'
            $('input', this).prop("required", true)