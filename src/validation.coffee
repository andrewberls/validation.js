window.ValidateJS = {
  # Public: Class of form elements to check on submission
  formClass: 'form-validate'

  # Public: Class added to invalid fields
  errClass: 'field-error'

  # Public: Whether or not to check validity on blur
  enableActiveChecking: false

  # Internal: Selector for input types to check
  inputTypes: 'input[type=text],input[type=email],input[type=password],textarea'

  # List of user-defined validation functions
  validators: {}

  addValidator: (name, fn) ->
    @validators[name] = fn
}


# Shield your eyes, here be dragons
ValidateJS.patterns = {
  url: /[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/
  email: /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
}


# Return true if input is not blank
ValidateJS.addValidator 'present', (input) ->
  input != ''


# Return true if input looks like a number
ValidateJS.addValidator 'number', (input) ->
  !(isNaN parseFloat(input))


# Return true if input looks like a URL
ValidateJS.addValidator 'url', (input) ->
  input.match(ValidateJS.patterns.url) != null


# Return true if input looks like an email
ValidateJS.addValidator 'email', (input) ->
  input.match(ValidateJS.patterns.email) != null


# Determine if a field needs validation
# i.e., skip over fields that have been explicitly marked with
# data-validate="false" (default: true)
# Optional fields are not checked here
ValidateJS.shouldValidate = ($field) ->
  validateFlag   = $field.data('validate')
  shouldValidate = if validateFlag? then validateFlag else true
  return shouldValidate


# Determine if a field can be skipped if it is marked
# as optional and left blank (default: false)
ValidateJS.optionalSkip = ($field) ->
  optionalFlag = $field.data('optional')
  optional     = if optionalFlag? then optionalFlag else false
  return optional && $field.val() == ''


# Determine if a field is valid, taking into account flags such as
# data-validate, data-optional, and data-validator
#
# If a custom validator is specified (ex: `data-validator="number"`)
# the field is checked accordingly. Otherwise, it is just ensured not to be blank
# Note that optional fields left blank are counted as valid
#
# Returns Boolean
ValidateJS.isValid = ($field) ->
  return true if !@shouldValidate($field)
  return true if @optionalSkip($field)

  val = $field.val()
  validators = ($field.data('validator') || '').split(' ').filter (e) -> e
  validators.push('present')
  for validatorName in validators
    if @validators[validatorName].call(window, val) == false
      $field.addClass(@errClass)
      return false

  return true


$ ->

  formClass  = ValidateJS.formClass
  errClass   = ValidateJS.errClass
  inputTypes = ValidateJS.inputTypes
  $form      = $(".#{formClass}")

  # Prevent form submissions if any fields are blank
  $form.submit ->
    errors = false

    # Check all fields that do not explicitly list `data-validate=false`
    for field in $(@).find(inputTypes)
      $field = $(field).removeClass(errClass)
      if !ValidateJS.isValid($field)
          errors = true
          $field.addClass(errClass)

    return !errors


  # Remove the error class if we add a valid value
  $(document).on 'keyup', ".#{errClass}", ->
    $(@).removeClass(errClass) if $(@).val()


  # Perform validity checking on blur if enabled
  if ValidateJS.enableActiveChecking
    $form.find(inputTypes).on 'blur', ->
      $field = $(@)
      if !ValidateJS.isValid($field)
        $field.addClass(errClass)
