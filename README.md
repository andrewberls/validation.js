## validation.js

validation.js provides a simple mechanism for preventing form submissions that contain invalid fields on the client side.
Simply add a class of `form-validate` to any form, and validation.js will automatically check it.
By default, it will simply prevent submission if any fields are blank, but it can be configured to perform rudimentary type checking as well.

### Examples
The best way to demonstrate is through actual interaction with a form - you can find an example [here](http://fake.com).

### Usage
First include the script on your page:

```html
<script src="path/to/validation.min.js"></script>
```

Adding a class of `form-validate` to any `<form>` element will mark it for validation checking.
By default, all inputs in the form are checked, but you can manually exclude any field by adding a `data-validate` attribute and setting it to `"false"`.


### Customization
By default, validation.js will add a class of `"field-error"` to any invalid field and `return false` in the case of any errors.
Customization options are exposed through the `ValidateJS` object on the window. Available options are:

```javascript
ValidateJS.formClass = "validated-form"          // Default: "form-validate"

ValidateJS.errClass = "custom-field-error-class" // Default: "field-error"

ValidateJS.enableActiveChecking = true           // Default: false
```

If active checking is enabled with the `enableActiveChecking` flag, an error class will be added if the field is invalid when it loses focus (hooked to the `blur` event).
You can see an example of active checking enabled [here](http://www.fake.com).

### Type checking
Ordinarily, validation.js only prevents form submissions with blank fields.
However, basic type checking is possible through the use of the `data-validate-type` attribute. Currently, only the `number` type is
supported and is used as follows:

```
<input type="text" placeholder="Enter amount" data-validate-type="number" />
```

Note that the HTML5 `<input type="number">` may also be appropriate, depending on your use case. You can see numeric type checking in action [here](http://fake.com).

### To Do
* email validation
* alert-style error boxes, slide-downs, etc
* Inline notifications