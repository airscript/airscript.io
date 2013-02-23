Airscript.init = ->
  Airscript.eventBus = new ko.subscribable()

  {ViewModels} = Airscript

  editor = new ViewModels.Editor()

  ko.applyBindings editor, document.querySelector('section.content')
  ko.applyBindings editor, document.querySelector('.gist_modal')

  $('.gist_modal').modal('show')
