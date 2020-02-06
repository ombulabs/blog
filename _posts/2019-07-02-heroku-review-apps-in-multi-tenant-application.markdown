---
layout: post
title: "Setup Heroku Review Apps in a multi-tenant application"
date: 2019-07-02 09:00:00
categories: ["heroku"]
author: "cleiviane"
published: false
---

Recently at [Ombu Labs](https://www.ombulabs.com) I had the mission of setting up Heroku [Review Apps](https://devcenter.heroku.com/articles/github-integration-review-apps) for one of our projects. Since the project is built in a multi-tenant architecture (using the [apartment gem](https://github.com/influitive/apartment)) it was a bit challenging to setup.

<!--more-->

### What are Review Apps?
Review Apps is a feature of Heroku that automatically deploys each pull request’s code to a new Heroku application. It's an excellent resource to help others (specially code reviewers) to visualize and understand the changes that were made.

### Enabling Review Apps in Heroku
The first step is to enable the review apps feature for the desired app using the Heroku dashboard.

<div style="text-align: center; width: 500px;">
  <img src="/blog/assets/images/heroku/enable-review-apps.png">
</div>

Choose a parent app in your pipeline that’s connected to the correct GitHub repository and click on "**Create an app.json File**".

<div style="text-align: center; width: 500px;">
  <img src="/blog/assets/images/heroku/enable-review-apps-step-2.png">
</div>

### The app.json file

After you finish the previous step, a new file called app.json will be committed to the root path of the target repository. This is the config file used by Heroku to create new apps when pull requests are opened. It will look like this:

```
{
  "name": "my-new-app",
  "scripts": {},
  "env": {
    "LANG": {
      "required": true
    },
    "RACK_ENV": {
      "required": true
    },
    "DATABASE_URL": {
      "required": true
    }
  },
  "formation": {},
  "addons": [
  ],
  "buildpacks": [
  ],
  "stack": "heroku-18"
}
```

As you may guess, the `env` section lists the environment variables that should be copied from the parent app. Take a look at [this link](https://devcenter.heroku.com/articles/github-integration-review-apps#the-app-json-file) to see all available options for the `app.json` file.

### Setup Postgres
The next step is to add an add-on to connect the apps to heroku postgresql. In order to not affect the data in staging we need to tell heroku to setup the database url in a different environment variable. Remember that the staging database variable was `DATABASE_URL`, so let's use a new one called `REVIEW_APPS_DATABASE` <small>(yes, without the URL part)</small>:

```
"addons": [
  {
    "plan": "heroku-postgresql",
    "as": "REVIEW_APPS_DATABASE"
  }
```

### Copy DB to review app

The recommendation from Heroku is to use the `db/seeds` file to populate your initial database. But for this project we wanted to actually have a copy of the staging database. Since review apps use a limited resource for the database, copying the entire database would cause a database disruption. But since we are using tenants in our application ([apartment gem](https://github.com/influitive/apartment)) our strategy was to copy just one schema and prevent that issue.

To be able to dump and restore the DB we created a rails task:

```
desc 'Copyies a database from the staging url to review apps url.'
task :copy_database => :environment do |t, args|
  puts "copying database #{ENV['DATABASE_URL']} to #{ENV['BACKUP_DATABASE_URL']}"
  system("pg_dump -cOx #{ENV['DATABASE_URL']} " + '-n public --schema=\"MyTenant\"' + " | psql #{ENV['BACKUP_DATABASE_URL']}")
  system("bundle exec rails db:migrate")
end

```

and added a postdeploy instruction into the `app.json` to run the task:

```
"scripts": {
  "postdeploy": "bundle exec rake copy_database"
},
```

That's it!

## Conclusion

Review Apps are certainly a great resource provided by Heroku, but it can be a little tricky to configure in specific situations, so I hope this post is helpful for others facing the same situation.
