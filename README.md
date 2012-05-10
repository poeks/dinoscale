# Autoscale your Heroku apps #

## Installation ##

* Rename app.yml.sample to app.yml and add these jams:

```
  heroku:
    api_key: your_api_key
  sendgrid:
    username: you@email.com
    password: pass
    domain: yourdomain.com
    to_email: you@email.com
```

* Requires NewRelic addon for each app
* Customize config/database.yml to your environment and create the postgres database.
* Install the gems: ```bundle install```
* Bootstrap the db: ```bundle exec rake db:bootstrap RACK_ENV=you_dev```
* Add a cronjob to run every ten minutes for ```bundle exec rake heroku:autoscale RACK_ENV=you_dev```
* Add a cronjob to run hourly (or daily, weekly, etc if you don't update your heroku apps much) for ```bundle exec rake heroku:load RACK_ENV=you_dev```
* Add a cronjob to run hourly (or daily, weekly, etc if you don't update your heroku apps much) for ```bundle exec rake heroku:scrape RACK_ENV=you_dev```
* Run the server! (If you want--it's pretty much just informational.) You might want to add some auth.
* To enable autoscaling for an app run: ```bundle exec rake heroku:add_new_relic_key APP=app_name KEY=newrelic_api_key APP_ID=newrelic_app_id RACK_ENV=you_dev``` 