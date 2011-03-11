Capistrano plugin that posts change logs to Basecamp after deploy.

Currently, only Git SCM is supported. Before deploy, this plugin finds out the version SHA on the server and compares it to the version to be deployed. Difference in git log will be posted to Basecamp project.

## Installation

    gem install capistrano-basecamp

In your capistrano recipe just require this plugin:

    require 'capistrano-basecamp'

Capistrano configuration

    set :basecamp_host, 'foo.basecamphq.com'  # Basecamp account url
    set :basecamp_project, 4873268            # Project ID in Basecamp to post message to

Optional configuration options

    set :basecamp_username, 'john'            # Basecamp username
    set :basecamp_password, 'secret'          # Basecamp account password
    set :basecamp_category, 53721442          # Category under project in Basecamp
    set :basecamp_ssl, true                   # true by default, set to false if you do not use SSL

If username and password are not provided in configuration, they will be asked on the first go and stored in PLAIN TEXT to `~/.basecamp.capistrano` file.

## TODO:

* Proper support for basecamp_post configuration option. Should support these values:
 * `'auto'` -- message will be posted automatically
 * `'ask'` -- ask for user confirmation before posting each message
* Add support for other SCM's than Git
* Do not store basecamp account information in plain text in `~/.basecamp.capistrano`
