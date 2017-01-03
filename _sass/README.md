# The Included CSS Styles

The `_sass` directory contains the SASS parts used for building the final CSS file.
All parts are merged into a single CSS file to make the download more efficient.

The CSS style is based on the [Flatly Bootswatch](https://bootswatch.com/flatly/)
theme which is based on the [Bootstrap](https://getbootstrap.com/) library.


## The Upstream Styles

- The `bootstrap` subdirectory contains the official Bootstrap SASS sources, see the
  respective [GitHub repository](
  https://github.com/twbs/bootstrap-sass/tree/master/assets/stylesheets).
  Do not forget to update the respective JavaScript library (`bootstrap.min.js`)
  in the `assets/javascripts` directory when updating the Bootstrap library.

- The `bootswatch` subdirectory contains the Flatly theme, the sources are located in
  two files: [_variables.scss](https://bootswatch.com/flatly/_variables.scss)
  and [_bootswatch.scss](https://bootswatch.com/flatly/_bootswatch.scss).

- The `fontawesome` subdirectory contains additional icons provided by the
  [FontAwesome project](http://fontawesome.io/). The downloaded [ZIP archive](
  http://fontawesome.io/get-started/#modal-download) contains also the SCSS
  sources, see the [description](
  http://fontawesome.io/get-started/#download-preprocessors) for more details.

## Our Customizations

The main file (`assets/stylesheets/style.scss`) loads the upstream libraries
mentioned above and also it loads our specific customizations. The loading order
is important as some files contains variable definitions which are used later.

The Bootstrap/Bootswatch customization is present in the
`custom/_bootswatch_overrides.scss` file.

Some additional variables are defined in the `custom/_variables.scss` file.

The other files contains the logically grouped customizations, if you want to
add a new custom rule add it to a related file or create a new file. All
files are merged into a single CSS final file, splitting the style into smaller
parts is cheap and makes it more readable. Just do not forget to include the
new added files in the main `style.scss` file!

### Notes

Use variables, avoid hardcoding values (esp. the colors). Preferably
use the `darken()`, `lighten()`, etc... helpers to build new colors from
the base colors.

You can use the Bootstrap helper methods localed in the `bootstrap/mixins/*`
files.

## Debugging

Unfortunately Jekyll cannot build the `.map` file for the CSS stylesheet
to display the locations in the original SASS files in supported browsers
(Chrome/Chromium). That makes style debugging much easier.

However, there is a helper script `sass_debug` which builds the debugging files
manually. But any Jekyll rebuild will overwrite the files back by the Jekyll
version so you have to run the script again after any change if you still need
the debugging info.

