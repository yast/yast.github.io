---
layout: post
title: "How to Write a New Post"
description: "Is it difficult to write a new post for a Jekyll based blog?"
category: howto
# FIXME: discussion is not supported yet
discussion: true
# FIXME: temporarily hidden
published: false
tags: [ blog ]
---

There are basically two ways how to write a new blog post.

- Create the post locally in your Git checkout and open a pull request (just like with the normal code changes)
- Create the post directly at GitHub

# Creating a Post Locally

- Clone the Git repository
- Create a new Markdown file in `_posts` directory - follow the same file naming schema,
  use a similar header like in the other posts
- Add images to `images` directory, use a new subdirectory if you need to add
  several images related only to a single post
- Hint: If you use the [Atom](https://atom.io/) editor you can use the live preview feature:
<iframe width="560" height="315" src="https://www.youtube.com/embed/5fZ9SlUoOqQ" frameborder="0" allowfullscreen></iframe>

# Creating a Post at GitHub

- Open the [https://yast.github.io/blog/new_post](https://yast.github.io/blog/new_post) page
- Fill the title for the new post
- Press the `Propose Post` button
- You will be redirected at GitHub where a new post file will be proposed
- Use the `Preview` tab to see the rendered Markdown  
  ![preview screenshot]({{site.baseurl}}/images/new-post/preview.png)
- When saving the file use the `Create a new branch for this commit` option at the bottom  
  ![commit screenshot]({{site.baseurl}}/images/new-post/commit.png)
- Then you can either open a pull request if the post is finished or you can
  continue editing it (adding more commits)
- You can upload images using the `Upload file` button in the repository browser
