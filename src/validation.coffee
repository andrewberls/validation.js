window.ValidateJS = {
  # Public: Class of form elements to check on submission
  formClass: 'form-validate'

  # Public: Class added to invalid fields
  errClass: 'field-error'

  # Public: Whether or not to check validity on blur
  enableActiveChecking: false

  # Internal: Selector for input types to check
  inputTypes: 'input[type=text],input[type=email],input[type=password],textarea'
}


# Helper function to determine if a field is valid
# If a validate-type data attribute is specified (ex: 'number'),
# the field is checked accordingly. Otherwise, it is just ensured
# not to be blank
isValid = ($field) ->
  val  = $field.val()
  if $field.data('validate-type') == 'number'
    !(isNaN parseInt(val))
  else
    val != ''


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
      validateFlag   = $field.data('validate')
      shouldValidate = if validateFlag? then validateFlag else true

      if shouldValidate && !isValid($field)
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
      $field.addClass(errClass) unless isValid($field)
