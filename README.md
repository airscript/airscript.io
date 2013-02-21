## Airscript UI

## Developers

### Requirements

* Python 2.7
* Git
* [Heroku Toolbelt](https://toolbelt.heroku.com/)

### Setup
Setup installs the package in develop mode with its dependencies and
tries to add a Heroku remote for deploying. You need to be a
collaborator of the app for deploy to work.

    make setup

### Run
Runs the server locally on port 5000:

    make run

### Deploy
If you have the ability to deploy, make sure you're up to date with
what's running and then you can push to Heroku:

    make deploy_pull
    make deploy
