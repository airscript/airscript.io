ko.bindingHandlers.selected =
  update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
      selected = ko.utils.unwrapObservable(valueAccessor())

      element.select() if (selected)

Airscript.init = ->
  {ViewModels} = Airscript

  editor = new ViewModels.Editor()

  ko.applyBindings editor, document.querySelector('body')

  $('.gist_modal').modal('show')

$ ->
  new ZeroClipboard document.querySelector('.script_path'),
    moviePath:'/flash/ZeroClipboard.swf'
