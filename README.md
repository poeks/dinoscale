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
* Install the gems: ```bundle install```
* Bootstrap the db: ```bundle exec rake db:bootstrap```
* Add some cronjobs per the Rakefile
* Run the server! (If you want--it's pretty much just informational.)
* To enable autoscaling for an app run: ```bundle exec rake heroku:add_new_relic_key APP=app_name KEY=newrelic_api_key APP_ID=newrelic_app_id``` 