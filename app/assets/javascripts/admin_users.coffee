$(document).on 'turbolinks:load', ->
  $('.field_with_errors').addClass 'error-field-fix'
  $('.form-group > .field_with_errors').addClass 'col-lg-2'
  $('.field_with_errors > label').removeClass 'col-lg-2'
  return