## validation.js

validation.js provides a simple mechanism for preventing form submissions that contain invalid fields on the client side.
Simply add a class of `form-validate` to any form, and validation.js will automatically check it.
By default, it will simply prevent submission if any fields are blank, but it can be configured to perform rudimentary type checking as well.

### Examples
The best way to demonstrate is through actual interaction with a form - you can find an example [here](http://andrewberls.github.io/validation.js/examples/basic.html).

### Usage
First include the script on your page:

```html
<script src="path/to/validation.min.js"></script>
```
Note that validation.js depends on jQuery.

Adding a class of `form-validate` to any `<form>` element will mark it for validation checking.
By default, all inputs in the form are checked, but you can manually exclude any field by adding a `data-validate` attribute and setting it to `"false"`.


### Customization
By default, validation.js will add a class of `field-error` to any invalid field and return false in the case of any errors.
It is up to the developer to style the `field-error` class as they wish.
Customization options are exposed through the `ValidateJS` object on the window. Available options are:

```javascript
ValidateJS.formClass = "my-validated-form"          // Default: "form-validate"

ValidateJS.errClass = "custom-field-error-class"   // Default: "field-error"

ValidateJS.enableActiveChecking = true             // Default: false
```

### Active Checking
If active checking is enabled with the `ValidateJS.enableActiveChecking` flag, an error class will be added if the field is invalid when it loses focus (hooked to the `blur` event).
You can see an example of active checking enabled [here](http://andrewberls.github.io/validation.js/examples/active_checking.html).


### Validators
ValidateJS ships with a number of predefined validation formats (such as emails and URLs), referred to as "validators"
to ensure that input matches a certain format, and also allows for user-defined validation functions.

Validators are specified on inputs using the `data-validator` attribute. Currently, the built-in validators are `number`, `email`, and `url`. Example:

```html
<input type="text" placeholder="Enter amount" data-validator="number" />
<input type="text" placeholder="Enter email" data-validator="email" />
<input type="text" placeholder="Enter url" data-validator="url" />
```

The `data-validator` attribute is expected to be a space-separated list of names in the case of multiple validators (similar to CSS classes)

Note that the HTML5 `<input type="number">` or `<input type="email">`may also be appropriate, depending on your use case. It is worth noting that
both predefined and custom validators work with active checking (i.e., on the blur event) whereas the HTML5 equivalents do not.

Custom validators are defined with a name and a function that, given a field input, returns `true` for valid inputs and `false` for invalid ones.
A sample validator that only accepts the number 2 looks like the following:

```javascript
ValidateJS.addValidator('isTwo', function(input) {
  return parseInt(input) === 2;
});
```


### Optional fields

It is possible to specify fields that are optional (i.e., can be left blank), but will be validated
if a value is present. This is accomplished using the `data-optional` attribute:

```
<input type="text" placeholder="Enter your lucky number, or not" data-optional="true" data-validator="number" />
```

Note that the `data-validate` attribute always takes precedence over any `data-optional` specifier.

### Contributing
validation.js is a CoffeeScript project built with [Arabica](http://andrewberls.github.io/arabica/).
After making changes to the CoffeeScript source, build the project by running `arabica build` and submit a pull request!
