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
* Add some cronjobs per the Rakefile
* Run the server!