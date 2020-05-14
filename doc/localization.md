# Localization

We use [FastGettext](https://github.com/grosser/fast_gettext) in YaST for
translating the strings. The PO/MO file backend is used so the translation
process is the same as translating any other program which uses the GNU gettext.


## Collecting the Translatable Strings

Run this command (in a GIT checkout):

```sh
rake pot
```

The rake command scans all sources for translatable strings and creates
the `<textdomain>.pot` files. Usually only one file is created per YaST module.

# Notes for Developers

## Translation Marks

All texts which should be translated needs to be wrapped in `_()` translation
function.

## Notes for Translators

Currently YaST copies the complete comment which precedes the translated string.

```ruby
# This comment is part of the pot file
# TRANSLATORS: this comment is part of the pot file
# as well.
_("Something to translate.")
```

However it is recommended to use the `TRANSLATORS:` keyword to be compatible with
GNU gettext which copies only the text *after* this keyword. This would allow us
to skip the comments not relevant for translators.


## Plural Forms

Use `n_()` for plural forms to have a nice looking text with numbers or lists:

```ruby
  n_("%s package", "%s packages", packages.size) % packages.size
```

The first string contains singular form, the second one plural form.

*Note: it is also possible to use a word (like *a* or *one*) instead of a
number for the singular case:*
```ruby
  n_("One package", "%s packages", packages.size) % packages.size
```

But be careful when using more format specifiers (e.g. `%s`), this will not work
in singular case correctly (will use wrong parameter):

```ruby
n_("One package from %s", "%s packages from %s", packages.size) %
  [ packages.size, repo ]
```

In that case you need to use named parameters:

```ruby
n_("one package from %{repo}", "%{size} packages from %{repo}", packages.size) %
  { :repo => repo, :size => packages.size }
```

See the [GNU gettext manual](
http://www.gnu.org/savannah-checkouts/gnu/gettext/manual/html_node/Plural-forms.html)
for more details about plural forms.

## Using Named Parameters

The named parameters mentioned in the previous section allow translators to
change the order of parameters in translations (which might be necessary in
some languages in some cases), so it makes sense to use them also in simple `_()`
case.

Named parameters can also help to understand the meaning of the value
(`%{package}` is easier to understand than `%s`), they can help to translate
the string properly.

## Translating Constants

Use `N_()` for translating Ruby constants, it does not translate the string at runtime
but it will be found when creating the pot file. Then use `_()` when it needs to be
translated later:

```ruby
class Foo
  # ERROR_MSG will not be translated, but the string will be found by gettext
  # when creating the .pot file
  ERROR_MSG = N_("Something failed")
end

# translate the string
puts _(Foo::ERROR_MSG)
change_language
# here it will correctly use the new language
puts _(Foo::ERROR_MSG)
```

## Interpolations

Be careful when mixing translations and string (or regular expression)
interpolations, this usually does not work.

### Interpolations in Translated Text

#### Example

``` ruby
_("Current time: #{time}")
```

#### Problems

This does not work at all. There are two problems:

- Ruby gettext cannot extract the text with interpolations correctly,
  the generated POT file contains a broken string.
- At runtime the string will not be found in the translation database as gettext
  receives the *already expanded* string.

Note: In some cases the text can be included in the generated POT (e.g.
`_("Current time is #{Time.now}")`) but the POT file will contain the expanded
string which is very likely useless
(`msgid "Current time is 2017-05-22 13:28:30 +0200"`) and will never match at
runtime.

#### Solutions

As already mentioned earlier, use the `%` operator or the `format` method on the
*translated* string.

``` ruby
_("Current time is %s") % [ time ]
format(_("Current time is %s"), time)
```

### Translated Text in Interpolation

#### Example

``` ruby
"<li>#{_("Item")}</li>"
# the same problem exists with regular expression literals
/#{_("Item")}/
```

#### Problem

This should work at runtime but the problem is that Ruby gettext cannot extract
the text into the POT file. That means unless the very same text is used somewhere
else the translators will not translate it.

#### Solutions

Move the translatable text outside the interpolation so it can be found when
collecting the translatable strings.

- Use the `+` operator instead of the interpolation
- Use a helper variable

##### Examples

``` ruby
"<li>" + _("Item") + "</li>"

item = _("Item")
"<li>#{item}</li>"
```

## Gettext Language Tags

The GNU Gettext supports several [language format tags](
https://www.gnu.org/software/gettext/manual/gettext.html#Translators-for-other-Languages
) which describe the format for the positional arguments. This enures that the
translated strings contain the same placeholders as the original
string.

In the YaST Ruby code we basically use two kinds of formats, the old YCP format
(`"%1"`) and new Ruby variants (`"%s"` and `"%{foo}"`). The YCP format is
natively supported by Gettext, it works out of box. Unfortunately the Ruby
format is not supported at all.

But for the `"%s"` style we can use the `c-format` and for the `"%{foo}"`
format we can use the `perl-brace-format`. That is not exactly the same as
in Ruby (Perl uses simpler `"{foo}"` format without the percent sign at the
beginning) but is close enough and should avoid most of the usual translation
bugs.

Ruby supports additional format with angled braces (`"%<foo>s"`) but because
there is no suitable equivalent in any Gettext format this should not be used
in the YaST code.

The Gettext language format tags are added by a [post-processing script](
https://github.com/yast/yast-devtools/blob/master/build-tools/scripts/po_add_format_hints
), after creating the POT file.
