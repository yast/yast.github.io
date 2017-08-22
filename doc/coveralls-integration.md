# Coveralls Integration

## Introduction

[Coveralls](https://coveralls.io/) provides free hosted stats about the code
coverage of the automated tests in a Github repository, allowing to know how the
situation will change after merging every pull request.

Most YaST repositories use Coveralls to check the coverage of the RSpec-based
unit tests, helping the developers to get an overview of the status of every
repository and to check the impact of every pull request in that regard.

## Prerequisites

Coveralls integration is based on Travis CI. Check the [Travis integration
document](travis-integration.md) if the continuous integration in Travis is
still not enabled for the repository.

This document explains how to enable coverage reporting for YaST repositories
using RSpec. If the repository doesn't include RSpec unit tests, please check
the [How to Write Tests document](how-to-write-tests.md).

## Coveralls Configuration

First of all, the repository must be registered in Coveralls. That's as easy as:

1. Log into [Coveralls.io](https://coveralls.io) using your Github account.
2. Go to "add repos" and search for the repository you want to enable.
3. Enable it with a single click.

## Repository Configuration

In the repository side, the configuration is also rather simple.

First of all, RSpec should be configured to report the test coverage. All YaST
repositories using RSpec contain a file called `test/test_helper.rb` or
`test/spec_helper.rb` with the RSpec initialization code. Some lines like these
should be added to that file.

```ruby
if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    # Don't measure coverage of the tests themselves.
    add_filter "/test/"
  end

  # track all ruby files under src
  src_location = File.expand_path("../../src", __FILE__)
  SimpleCov.track_files("#{src_location}/**/*.rb")

  # use coveralls for on-line code coverage reporting at Travis CI
  if ENV["TRAVIS"]
    require "coveralls"
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      Coveralls::SimpleCov::Formatter
    ]
  end
end
```

Since the calculation of the test coverage will generate a directory with the
corresponding report, this line should be added to the `.gitignore` file.

```
coverage/
```

Last but not least, it's desirable to show the current status in the front page
of the repository. For that purpose, the Coveralls badge can be added including
a line similar to this in the `README.md` file.

```
[![Coverage Status](https://img.shields.io/coveralls/yast/yast-foobar/master.svg)](https://coveralls.io/github/yast/yast-foobar?branch=master)
```
