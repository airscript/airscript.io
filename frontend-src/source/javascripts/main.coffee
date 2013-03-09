Airscript.init = ->
  {ViewModels} = Airscript

  editor = new ViewModels.Editor()

  ko.applyBindings editor, document.querySelector('body')

  $('.gist_modal').modal('show')

$ ->
  new ZeroClipboard document.querySelector('.clipboard'),
    moviePath:'/flash/ZeroClipboard.swf'
