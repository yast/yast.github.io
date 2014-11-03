# Building this Documentation Locally

This documentation is also built at
[http://yastgithubio.readthedocs.org](http://yastgithubio.readthedocs.org) server.

The problem is that Markdown rendering is not standardized and each renderer
can produce a slightly different output. That means the HTML version might be displayed
differently at readthedocs.org than at GitHub.

If you write a longer documentation it would be nice to see the result locally,
without need to push to GitHub and then fixing the result.


## Prerequisites

You need to install `mkdocs` tool which is used for building the HTML documentation
at readthedocs.org. Run as root:

    zypper in python-pip python-PyYAML python-devel
    # mkdocs is not packaged, use pip to install it
    pip install mkdocs


## Building the Documentation

### Manual Build

For single run you can use these commands:

    # (re)generate the documentation
    mkdocs build --clean
    # open the local generated file
    xdg-open site/README/index.html


### Local Documentation Server

If you work on the documentation and you want to see the current rendered version
then it is a good idea to run the documentation server. The advantage is that the
server watches the documentation changes and regenerates it automatically whenever
a file is modified. You just need to reload the file in the browser.

    # run the server
    mkdocs serve --clean
    # open this local URL
    xdg-open http://127.0.0.1:8000/README/


## Documentation

You can find more details directly at [the readthedocs.org documentation](
https://docs.readthedocs.org/en/latest/getting_started.html#in-markdown).

