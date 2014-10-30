How to Write Tests
==================

Why
---
You most probably know why it's a good idea to write tests, but let's name some
of the reasons here:

* Automatic tests can run 24/7, which is way way more effective than testing
  code manually
* Tests can capture what a code is expected to do and, if well done, it does not
  let us introduce regressions
* Each code will eventually break, but you may not find out without tests
* People might be afraid of a change if they can't guarantee all the code still
  does what it's expected to do - tests give you the confidence for change
* Bad and ugly test makes you write a good API
* Test output (RSpec) can help with documentation

How
---
Yast team uses RSpec for ther tests. Here are some basic rules that all Yast
projects should follow:

* Test must be readable - everyone has to easily understand what the test
  actually tests
* It's easy-to-maintain - no hacks, no magic
* Needs to cover the whole code, otherwise you would feel a false sense of
  security
* A test suite should be comprehensive but every individual test on it should
  be specific
* Test all aspects of a method (depending on context, and input), see Examples
* Uses "allow" for queries, but "expect" commands, see Examples
* Expectation in "it" block - must be explicit, see Examples
* Description of a test should describe the behavior - you should get the idea
  just be reading the "it" / "context", see Examples

Tips & Tricks
-------------
* [SCR helper](https://github.com/yast/yast-country/blob/master/keyboard/test/SCRStub.rb)
* Other helpers - TBD

Links
-----
- [Better Specs](http://betterspecs.org/) - rspec guidelines with Ruby
- [The RSpec Style Guide](https://github.com/reachlocal/rspec-style-guide)

Examples
--------
TBD:
* "allow" vs "expect"
* "expect" in "it"
* descriptive "it" / "context"
* "it" in different "context"s
