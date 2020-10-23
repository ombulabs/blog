# The OmbuLabs Blog

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

Blog for the [OmbuLabs team](https://www.ombulabs.com/#team), powered by [Jekyll](https://jekyllrb.com).

This is included as an engine in the [https://github.com/ombulabs/ombulabs.com](https://github.com/ombulabs/ombulabs.com) application.

## Installation

To get the blog up and running in a local environment, follow the steps below:

1. Clone the repository: `git clone git@github.com:ombulabs/blog.ombulabs.com.git`
2. Setup `.ruby-version` if you're using RVM.
3. Run `bundle install` to install Jekyll and other dependencies.
4. Start the blog by running `jekyll serve`.

You can then access the blog at [localhost:4000](http://localhost:4000) (default port).

By default, the auto-regeneration is enabled, so any changes on HTML, CSS or posts will be auto-regenerated/compiled and viewable by refreshing the browser.  

## Creating a new post

In order to create a new post, you can copy one of the existing posts (.markdown files) in `/_posts/` and change the filename to suit your post by modifying the date and title.

After saving the new file to `/_posts/`, you will see the post generated as HTML under `/_site/` and published to your local blog if it's running.

To edit the post, first change the YAML variables `post`, `date` and `categories`. You can also change `layout` to use one of the layouts under `/_layouts/` (only post and page exist for now).

Then, you can begin writing your post by replacing the existing copy beneath. NOTE: It should be written using Markdown syntax.

After you're done, simply save the file, and (optionally) run the blog locally if it's not already running to preview it.

## Publishing a post

In order to publish your newly created post, simply create a branch and make a Pull Request. When the branch is merged and deployed, the post will be displayed in the blog.  

## Editing a post

To edit a post, simply edit the content for one of the markdown files and the HTML for the post will regenerate.

## Deleting a post

To delete a post, you can unpublish it by setting a `published` flag under the post's YAML variables, see: http://jekyllrb.com/docs/frontmatter/

## To deploy

See OmbuLabs repository instructions - "As is we don't have automatic deployments for the blog, so you can run bin/deploy for now."
