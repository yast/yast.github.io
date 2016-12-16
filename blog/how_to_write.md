---
layout: default
title: "How to Write a New Post"
description: "A short introduction about writing new blog posts"
sitemap: false
---

# Contents

* This line will be replaced with the ToC
{:toc}


# Creating a New Post

There are basically two ways how to write a new blog post:

- Create the post locally in your local Git checkout and open a pull request
  (just like with the normal code changes).
- Create the post directly at GitHub and edit it in the online editor.

## Creating a Post Locally

- Clone the [Git repository](https://github.com/yast/yast.github.io) locally
  and create a new branch
- Create a new Markdown file in the `_posts` directory - follow the same file
  naming schema and use a similar YAML header like in the other posts. (It
  is recommended to generate the post template online, see the previous section.)
  The YAML front matter values are partially documented
  [here](https://jekyllrb.com/docs/frontmatter/) and
  [here](http://jekyll.tips/jekyll-casts/front-matter/) and even
  [here](https://github.com/jekyll/jekyll-sitemap#exclusions).
- Add images to the `/assets/images/blog/<YYYY>-<MM>-<DD>` subdirectory
- Hint: If you use the [Atom](https://atom.io/) editor you can use the
  [live preview feature](https://www.youtube.com/watch?v=5fZ9SlUoOqQ) or
  [render the pages locally](#rendering-the-pages-locally).

## Creating a Post at GitHub

- Open the [New Blog Post](https://yast.github.io/blog/new_post) page
- Fill up the form and press the `Generate Template` button
- You will be redirected at GitHub where a new post file will be proposed,
  the template will contain the values from the form.
- Use the `Preview changes` tab to see the rendered Markdown  
  ![preview screenshot]({{site.baseurl}}/assets/images/blog/new-post/preview.png)
- When saving the file use the `Create a new branch for this commit` option at the bottom  
  ![commit screenshot]({{site.baseurl}}/assets/images/blog/new-post/commit.png)
- Then you can either open a pull request if the post is finished or you can
  continue editing it (adding more commits)
- You can upload images using the `Upload file` button in the repository browser

# Markdown Hints

## Documentation

The site uses the Jekyll framework for generating the pages and Kramdown
syntax (a Markdown flavor) for the blog posts.

Here you can find the relevant documentation:

- The [Kramdown quick reference](https://kramdown.gettalong.org/quickref.html)
- The [Kramdown documentation](https://kramdown.gettalong.org/syntax.html)
- The [Jekyll documentation](http://jekyllrb.com/docs/home/)
- Some useful [Jekyll tips](http://jekyll.tips/)

## Images

There is a [`blog_img.md`](https://github.com/yast/yast.github.io/blob/master/_includes/blog_img.md)
include file which contains a helper for rendering the local images. For the
external images use the usual Markdown syntax, see [below](#external-images).

### Internal Images

Each blog post should contain the relevant images at the
`/assets/images/blog/<YYYY>-<MM>-<DD>` subdirectory, the date in last part
should be the same as in the post file name.

The helper supports several use cases:

- Simple image with an alt text, the CSS style sets maximum width to 100%
  so the image does not overflow the text column:

```liquid
{% raw %}{% include blog_img.md alt="Alt text" src="file.png" %}{% endraw %}
```

- Scaled down image (thumbnail size), clicking the small image displays
the original full size image:

```liquid
{% raw %}{% include blog_img.md alt="Alt text" src="file.png" attr=".thumbnail" %}{% endraw %}
```

- Image that will be displayed when clicking on a explicitly provided thumbnail:

```liquid
{% raw %}{% include blog_img.md alt="Alt text" src="file_small.png" full_img="file.png" %}{% endraw %}
```

### External Images

For external images (hosted outside the blog) use the usual `![]()` Markdown
syntax. If you want to use a thumbnail for an external images use the
Kramdown attribute extension:

```markdown
![Alt](http://example.com/img.jpg){: .thumbnail}
```

See more details in the [documentation](https://kramdown.gettalong.org/syntax.html#images).

## Links to the Older Posts

Build the link URL using the `post_url` helper followed by post file name
without the `.md` suffix.

```liquid
{% raw %}[old post link]({{ site.baseurl }}{% post_url 2015-12-15-let-s-blog-about-yast %}){% endraw %}
```

## Syntax Highlighting

Use the usual fenced code blocks just like at GitHub:

    ```ruby
    puts "Hello world!"
    ```

is rendered as

```ruby
puts "Hello world!"
```

or this example

    ```xml
    <foo bar="yes">baz</foo>
    ```

is rendered as

```xml
<foo bar="yes">baz</foo>
```

## Emoji

Use emoji shortcuts like at GitHub: `:smiley:` :smiley:, `:wink:` :wink:,
`:+1:` :+1:, `:sparkles:` :sparkles: ...

See the [emoji cheat sheet](http://www.webpagefx.com/tools/emoji-cheat-sheet/)
page for the complete list.

# Rendering the Pages Locally

Install Jekyll and the needed libraries using `bundler`:

    bundle install --path .vendor/bundle

Build the pages:

    bundle exec jekyll build

The generated HTML pages are saved into the `_site` subdirectory.

To avoid rebuilding the pages manually after each change you can run the Jekyll
server with the `--watch` option:

    bundle exec jekyll serve --watch

This will automatically rebuild the pages whenever a file is changed.
This also runs a web server at [http://127.0.0.1:4000/](http://127.0.0.1:4000/)
so you can browse the generated tree.

# Continuous Integration

[Travis CI](https://travis-ci.org/) runs some tests when a commit is pushed
to the GitHub repository or when a new Pull Request is opened.

## Running the Checks Locally

Install the needed dependencies first

    sudo zypper install aspell aspell-en aspell-devel

Then install the needed Ruby gems if you have not already done that

    bundle install --path .vendor/bundle

And run the checks:

    bundle exec rake
