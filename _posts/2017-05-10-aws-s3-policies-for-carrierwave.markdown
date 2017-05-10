---
layout: post
title:  "AWS S3 Policies for Carrierwave"
date: 2017-05-10 09:02:00
categories: ["aws", "carrierwave", "s3"]
author: "etagwerker"
---

When you create [IAM](https://aws.amazon.com/iam/) credentials and policies for
your app, you should make sure that they have access to the resources that they
need **and not more than that!**.

This way, if anyone gets access to those credentials, the impact of this leak
is reduced to the resources associated with them (**and not all the buckets in
your S3 account**)

<!--more-->

If you're using [Carrierwave](https://github.com/carrierwaveuploader/carrierwave),
you will *probably* need credentials that have **access** to these buckets:

* gif-dir-development
* gif-dir-test
* gif-dir-production

[Creating a policy for this is **not trivial**](http://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html)
using the AWS Administration Panel. If you follow the [instructions in the official AWS documentation](https://aws.amazon.com/blogs/security/writing-iam-policies-how-to-grant-access-to-an-amazon-s3-bucket/), you might run into this issue:

```bash
Excon::Error::Socket (Broken pipe (Errno::EPIPE)):
  app/controllers/gifs_controller.rb:64:in `block in create'
  app/controllers/gifs_controller.rb:63:in `create'

  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/actionpack-4.2.6/lib/action_dispatch/middleware/templates/rescues/_source.erb (11.7ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/actionpack-4.2.6/lib/action_dispatch/middleware/templates/rescues/_trace.html.erb (5.1ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/actionpack-4.2.6/lib/action_dispatch/middleware/templates/rescues/_request_and_response.html.erb (1.4ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/actionpack-4.2.6/lib/action_dispatch/middleware/templates/rescues/diagnostics.html.erb within rescues/layout (60.9ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/web-console-2.3.0/lib/web_console/templates/_markup.html.erb (0.5ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/web-console-2.3.0/lib/web_console/templates/_inner_console_markup.html.erb within layouts/inlined_string (0.3ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/web-console-2.3.0/lib/web_console/templates/_prompt_box_markup.html.erb within layouts/inlined_string (0.3ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/web-console-2.3.0/lib/web_console/templates/style.css.erb within layouts/inlined_string (0.6ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/web-console-2.3.0/lib/web_console/templates/console.js.erb within layouts/javascript (45.4ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/web-console-2.3.0/lib/web_console/templates/main.js.erb within layouts/javascript (0.7ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/web-console-2.3.0/lib/web_console/templates/error_page.js.erb within layouts/javascript (0.4ms)
  Rendered /Users/etagwerker/.rvm/gems/ruby-2.3.3@gifDir/gems/web-console-2.3.0/lib/web_console/templates/index.html.erb (102.7ms)
```

The issue is documented in Fog's [issue \#1659](https://github.com/fog/fog/issues/1659).
The problem with the official documentation is that it lists only 4 actions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::gif-dir-development"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::gif-dir-development/*"]
    }
  ]
}
```

These actions are not enough for [Carrierwave](https://github.com/carrierwaveuploader/carrierwave). You will need
to add the `"s3:PutObjectAcl"` action to the list. While you are at it, you
should add more buckets to the list of resources:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::gif-dir-development",
                "arn:aws:s3:::gif-dir-test",
                "arn:aws:s3:::gif-dir-production"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::gif-dir-development/*",
                "arn:aws:s3:::gif-dir-test/*",
                "arn:aws:s3:::gif-dir-production/*"
            ]
        }
    ]
}
```

After you've modified the policy's JSON, you can update it and associate it to
the IAM user using the AWS administration panel.
