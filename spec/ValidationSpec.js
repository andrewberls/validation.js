describe('builtin validators', function() {
  describe('present', function() {
    it('returns true for non-blank inputs', function() {
      var validator = ValidateJS.validators['present'];
      var $field    = $("<input type='text' name='title'>");
      $field.val('my interesting title');

      expect(validator.call(window, $field.val())).toBe(true);
    });

    it('returns false for blank inputs', function() {
      var validator = ValidateJS.validators['present'];
      var $field    = $("<input type='text' name='title'>");
      $field.val('');

      expect(validator.call(window, $field.val())).toBe(false);
    });
  });


  describe('number', function() {
    it('returns true for numeric-looking inputs', function() {
      var validator = ValidateJS.validators['number'];
      var $field    = $("<input type='text' name='amount'>");

      $field.val('22');
      expect(validator.call(window, $field.val())).toBe(true);

      $field.val('2.2');
      expect(validator.call(window, $field.val())).toBe(true);

      $field.val('0002');
      expect(validator.call(window, $field.val())).toBe(true);
    });

    it('returns false non non-numeric-looking inputs', function() {
      var validator = ValidateJS.validators['number'];
      var $field    = $("<input type='text' name='amount'>");
      $field.val('not a number');

      expect(validator.call(window, $field.val())).toBe(false);
    });
  });


  describe('url', function() {
    it('returns true for url-looking inputs', function() {
      var validator = ValidateJS.validators['url'];
      var $field    = $("<input type='text' name='url'>");

      $field.val('http://www.google.com');
      expect(validator.call(window, $field.val())).toBe(true);

      $field.val('http://google.com');
      expect(validator.call(window, $field.val())).toBe(true);

      $field.val('google.com');
      expect(validator.call(window, $field.val())).toBe(true);

      $field.val('mysite.io');
      expect(validator.call(window, $field.val())).toBe(true);

      $field.val('mysite.co.uk?param1=a&param2=b');
      expect(validator.call(window, $field.val())).toBe(true);
    });

    it('returns false non non-url-looking inputs', function() {
      var validator = ValidateJS.validators['url'];
      var $field    = $("<input type='text' name='url'>");
      $field.val('not a url');

      expect(validator.call(window, $field.val())).toBe(false);
    });
  });


  describe('email', function() {
    it('returns true for email-looking inputs', function() {
      var validator = ValidateJS.validators['email'];
      var $field    = $("<input type='text' name='email'>");

      $field.val('myname@gmail.com');
      expect(validator.call(window, $field.val())).toBe(true);

      $field.val('firstname.lastname@hotmail.com');
      expect(validator.call(window, $field.val())).toBe(true);

      $field.val('firstname+somethingelse@company.co.uk');
      expect(validator.call(window, $field.val())).toBe(true);
    });

    it('returns false non non-email-looking inputs', function() {
      var validator = ValidateJS.validators['email'];
      var $field    = $("<input type='text' name='email'>");
      $field.val('myemail@');

      expect(validator.call(window, $field.val())).toBe(false);
    });
  });
});


describe('shouldValidate', function() {
  it('is true by default', function() {
    var $field = $("<input type='text' name='title'>");
    expect(ValidateJS.shouldValidate($field)).toBe(true);
  });

  it('can be skipped with data-validate=false', function() {
    var $field = $("<input type='text' name='title' data-validate='false'>");
    expect(ValidateJS.shouldValidate($field)).toBe(false);
  });
});


describe('optionalSkip', function() {
  it('is true if field is marked optional and left blank', function() {
    var $field = $("<input type='text' name='title' data-optional='true'>");
    $field.val('');

    expect(ValidateJS.optionalSkip($field)).toBe(true);
  });


  it('is false if field is marked optional but has value present', function() {
    var $field = $("<input type='text' name='title' data-optional='true'>");
    $field.val('something needing validating');

    expect(ValidateJS.optionalSkip($field)).toBe(false);
  });
});



describe('isValid', function() {
  it('encompasses optional fields', function() {
    var $field = $("<input type='text' name='title' data-optional='true'>");

    $field.val('');
    expect(ValidateJS.isValid($field)).toBe(true);

    $field.data('optional', false);
    expect(ValidateJS.isValid($field)).toBe(false);
  });

  it('encompasses validation skips', function() {
    var $field = $("<input type='text' name='title' data-validate='false'>");

    $field.val('');
    expect(ValidateJS.isValid($field)).toBe(true);

    $field.data('validate', true);
    expect(ValidateJS.isValid($field)).toBe(false);
  });

  it('runs custom validators', function() {
    ValidateJS.addValidator('isTwo', function(input) { return input === '2' });
    var $field = $("<input type='text' name='the_magic_number' data-validator='isTwo'>");

    $field.val('2');
    expect(ValidateJS.isValid($field)).toBe(true);

    $field.val('3');
    expect(ValidateJS.isValid($field)).toBe(false);
  });

  it('runs multiple custom validators', function() {
    ValidateJS.addValidator('isEvenNum', function(input) {
      return parseInt(input) % 2 === 0
    });
    ValidateJS.addValidator('isEvenNumDigits', function(input) {
      return input.toString().length % 2 === 0
    });
    var $field = $("<input type='text' name='the_magic_number' data-validator='isEvenNum isEvenNumDigits'>");

    $field.val('22');
    expect(ValidateJS.isValid($field)).toBe(true);

    $field.val('234');
    expect(ValidateJS.isValid($field)).toBe(false);
  });
});
