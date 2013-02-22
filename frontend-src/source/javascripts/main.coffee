Airscript.init = ->
  Airscript.eventBus = new ko.subscribable()

  {ViewModels} = Airscript

  github = new ViewModels.Github()
  heroku = new ViewModels.Heroku()

  editor = new ViewModels.Editor()

  ko.applyBindings editor, document.querySelector('section.content')
  ko.applyBindings editor, document.querySelector('.gist_modal')

  ko.applyBindings github, document.querySelector('.github_modal')
  ko.applyBindings heroku, document.querySelector('.heroku_modal')
