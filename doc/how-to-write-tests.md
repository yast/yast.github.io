# How to Write Tests

## Why

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

## How

YaST team uses RSpec for [unit testing](https://en.wikipedia.org/wiki/Unit_testing)
and a mix of solutions, depending on each particular case, for
[integration testing](https://en.wikipedia.org/wiki/Integration_testing).

### Unit tests with RSpec

Here are some basic rules that all YaST projects should follow regarding RSpec
tests:

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

### Integration tests with openQA

Integration tests for all the openSUSE distributions are performed by
[the openSUSE openQA instance](https://openqa.opensuse.org). When possible, is
desirable to add tests for new features or bug fixes in YaST to the
[opensuse distri](https://github.com/os-autoinst/os-autoinst-distri-opensuse),
so they can be integrated in the continuous testing process of the distribution.

See the links section for more information about how to develop openQA tests for
YaST.

### AutoYaST integration tests

AutoYaST has its own framework for running integration tests by using Veewee,
Vagrant and Pennyworth. See the corresponding
[Github page](https://github.com/yast/autoyast-integration-test) for more
information.

### Tests for the command line with the Test Anything Protocol

Apart from the usual user interface, some YaST modules also offer a
non-interactive command line interface. In order to test that CLI, simple
TAP-compliant scripts are used. [TAP](http://testanything.org/), the Test
Anything Protocol, is a simple text-based interface between testing modules
in a test harness.

The CLI testing scripts are placed in a `t` directory at the root of each
YaST module and are executed using the command `prove`. This command is a
runner for the Test Anything Protocol which has a stdio interface and thus
is well suited for command line tests. The program is conveniently part of
a base openSUSE system, in `perl5.rpm`.

The scripts operate directly on the running system, which means that, although
most of them try to clean up after themselves, they can reconfigure the system.
As a consequence, they must be executed in a scratch virtual machine. For that
purpose, a specific openQA test module called
[yast2_cmdline.pm](https://github.com/os-autoinst/os-autoinst-distri-opensuse/blob/master/tests/console/yast2_cmdline.pm)
is used to run the scripts in a safe way. All modules with CLI integration tests
must be explicitly included in `yast2_cmdline.pm`.

# Links

* RSpec
  * [Better Specs](http://betterspecs.org/) - rspec guidelines with Ruby
  * [The RSpec Style Guide](https://github.com/reachlocal/rspec-style-guide)
  * [YaST RSpec helpers](http://www.rubydoc.info/github/yast/yast-ruby-bindings#Testing)
* openQA
  * [openQA landing page](http://os-autoinst.github.io/openQA/)
  * [yast-modules branch of the opensuse distri](https://github.com/os-autoinst/os-autoinst-distri-opensuse/tree/yast-modules)
