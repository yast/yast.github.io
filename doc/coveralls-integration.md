# Coveralls Integration

## Introduction

[Coveralls](https://coveralls.io/) provides free hosted stats about the code
coverage of the automated tests in a Github repository, allowing to know how the
situation will change after merging every pull request.

Most YaST repositories use Coveralls to check the coverage of the RSpec-based
unit tests, helping the developers to get an overview of the status of every
repository and to check the impact of every pull request in that regard.

## Prerequisites

Coveralls is directly used from CI. Check the [CI document](ci-integration.md)
if the continuous integration is still not enabled for your repository.

This document explains how to enable coverage reporting for YaST repositories
using RSpec. If the repository doesn't include RSpec unit tests, please check
the [How to Write Tests document](how-to-write-tests.md).

## Repository Configuration

The Coveralls authors provide the [Coveralls GitHub Action](
https://github.com/marketplace/actions/coveralls-github-action) which can be
easily integrated info the GitHub Action workflow.

Just run these two steps in the workflow:

```yaml
- name: Unit Tests
  run: rake test:unit
  # enable code coverage reporting
  env:
    COVERAGE: 1

# send the coverage report to coveralls.io
- name: Coveralls Report
  uses: coverallsapp/github-action@master
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

The first step runs the unit tests with enabled code coverage reporting,
the second step sends the coverage result to the coveralls.io server.


First of all, RSpec should be configured to report the test coverage. All YaST
repositories using RSpec contain a file called `test/test_helper.rb` or
`test/spec_helper.rb` with the RSpec initialization code. Some lines like these
should be added to that file.

```ruby
if ENV["COVERAGE"]
  require "simplecov"
  # start measuring the code coverage
  SimpleCov.start do
    # don't measure coverage of the tests themselves
    add_filter "/test/"
  end

  srcdir = File.expand_path("../src", __dir__)

  # track all ruby files under src
  SimpleCov.track_files("#{srcdir}/**/*.rb")

  # additionally use the LCOV format for on-line code coverage reporting at CI
  if ENV["CI"] || ENV["COVERAGE_LCOV"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      # this is the default Coveralls GitHub Action location
      # https://github.com/marketplace/actions/coveralls-github-action
      c.single_report_path = "coverage/lcov.info"
    end

    # generate both HTML and LCOV reports
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::LcovFormatter
    ]
  end
end
```

The code above enables code coverage tracking and reporting when `COVERAGE` environment
variable is set. The Coveralls GitHub Action expects the coverage data in
LCOV format stored in `coverage/lcov.info` file so we use the `simplecov-lcov`
and configure it as required.

## Running Code Coverage Locally

Run the `COVERAGE=1 rake test:unit` command, this will generate a HTML
report in the `coverage/index.html` file, just open it in a web browser.

## Notes

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
