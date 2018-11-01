$(document).ready ->
  $('.hubspot-form select.has_dependents').each ->
    option = $('option:selected', this).val()
    id = $(this).attr('id')
    checkSelect(option, id)

  $('.hubspot-form .radio.has_dependents input').each ->
    input_value = this.value
    id = $(this).closest('div').attr('id')
    checkRadio(input_value, id)

  $('.hubspot-form .booleancheckbox.has_dependents').each ->
    value = $(this).is(':checked')
    id = $(this).attr('id')
    checkBooleanCheckbox(value, id)

  $('.hubspot-form .checkbox.has_dependents input').each ->
    name = $(this).attr('name')
    values = $('input[type=checkbox][name=\'' + name + '\']:checked').map((_, el) ->
      $(el).val()
    ).get()
    id = $(this).closest('div').attr('id')
    checkCheckbox(values, id)

  $('.hubspot-form input.has_dependents, .hubspot-form textarea.has_dependents').each ->
    input_value = $(this).val()
    id = $(this).attr('id')
    checkInput(input_value, id)

  $('.hubspot-form select.has_dependents').on 'change', ->
    option = $('option:selected', this).val()
    id = $(this).attr('id')
    checkSelect(option, id)
    
  $('.hubspot-form .radio.has_dependents input').on 'change', ->
    input_value = this.value
    id = $(this).closest('div').attr('id')
    checkRadio(input_value, id)

  $('.hubspot-form .checkbox.has_dependents input').on 'change', ->
    name = $(this).attr('name')
    values = $('input[type=checkbox][name=\'' + name + '\']:checked').map((_, el) ->
      $(el).val()
    ).get()
    id = $(this).closest('div').attr('id')
    checkCheckbox(values, id)

  $('.hubspot-form .booleancheckbox.has_dependents').on 'change', ->
    value = $(this).is(':checked')
    id = $(this).attr('id')
    checkBooleanCheckbox(value, id)

  $('.hubspot-form input.has_dependents, .hubspot-form textarea.has_dependents').on 'keyup', ->
    input_value = $(this).val()
    id = $(this).attr('id')
    checkInput(input_value, id)
    
checkInput = (input_value, id) ->
  $.each $('.' + id), (key, value) ->
    $(this).hide()
    $('input, textarea, select', this).prop("required", false)
    str_value = $(this).attr('data-strValue')
    condition = $(this).attr('data-condition')
    required  = $(this).attr('data-required')
    if condition == 'IS_NOT_EMPTY'
      if input_value
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    if condition == 'CONTAINS'
      if input_value.indexOf(str_value) != -1 
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    if condition == 'DOESNT_CONTAIN'
      if input_value.indexOf(str_value) == -1 
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    if condition == 'EQ'
      if input_value == str_value
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    if condition == 'NEQ'
      if input_value != str_value
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    if condition == 'STR_STARTS_WITH'
      if input_value.indexOf(str_value) == 0
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    if condition == 'STR_ENDS_WITH'
      if input_value.slice(str_value.length * -1) == str_value
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)

checkSelect = (option, id) ->
  $.each $('.' + id), (key, value) ->
    $(this).hide()
    $('input, textarea, select', this).prop("required", false)
    str_values = $(this).attr('data-strValues')
    condition = $(this).attr('data-condition')
    required  = $(this).attr('data-required')
    keys = str_values.split('###')
    if condition == 'IS_NOT_EMPTY'
      if option
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'SET_ANY'
      if required == 'true'
          $('input, textarea, select', this).prop("required", true)
      if $.inArray(option, keys) != -1 or str_values == ''
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'SET_NOT_ANY'
      if $.inArray(option, keys) == -1 or str_values == ''
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)

checkRadio = (input_value, id) ->
  $.each $('.' + id), (key, value) ->
    $(this).hide()
    $('input, textarea, select', this).prop("required", false)
    str_values = $(this).attr('data-strValues')
    condition = $(this).attr('data-condition')
    required  = $(this).attr('data-required')
    keys = str_values.split('###')
    if condition == 'IS_NOT_EMPTY'
      if input_value
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'SET_ANY'
      if $.inArray(input_value, keys) != -1 or str_values == ''
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'SET_NOT_ANY'
      if $.inArray(input_value, keys) == -1 or str_values == ''
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)

checkBooleanCheckbox = (input_value, id) ->
  $.each $('.' + id), (key, value) ->
    $(this).hide()
    $('input, textarea, select', this).prop("required", false)
    str_value = $(this).attr('data-strValues')
    condition = $(this).attr('data-condition')
    required  = $(this).attr('data-required')
    if condition == 'EQ'
      if input_value.toString() == str_value
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'IS_NOT_EMPTY'
      if input_value.toString() == 'true'
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)

checkCheckbox = (values, id) ->
  $.each $('.' + id), (key, value) ->
    $(this).hide()
    $('input, textarea, select', this).prop("required", false)
    str_values = $(this).attr('data-strValues')
    condition = $(this).attr('data-condition')
    required  = $(this).attr('data-required')
    keys = str_values.split('###')
    if condition == 'SET_ANY'
      show = false
      $.each values, (index, value) ->
        if $.inArray(value, keys) != -1
          show = true
      if show
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'SET_EQ'
      if values.sort().join(',') == keys.sort().join(',')
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'SET_NEQ'
      if values.sort().join(',') != keys.sort().join(',')
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'SET_ALL'
      counter = 0
      $.each values, (index, value) ->
        if $.inArray(value, keys) != -1
          counter++
      if counter == keys.length
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'SET_NOT_ALL'
      counter = 0
      $.each values, (index, value) ->
        if $.inArray(value, keys) != -1
          counter++
      if counter != keys.length
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'IS_NOT_EMPTY'
      if values.length
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)
    else if condition == 'SET_NOT_ANY'
      show = true
      $.each values, (index, value) ->
        if $.inArray(value, keys) != -1
          show = false
      if show
        $(this).show()
        if required == 'true'
          $('input, textarea, select', this).prop("required", true)