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
  $('input.full_script_path').on 'keydown', (e) ->
    # prevent default unless they are pressing ctrl+c
    unless (e.metaKey || e.ctrlKey)
      unless (e.keyCode is 67 || e.keyCode is 65)
        e.preventDefault()

  $('li.script_path, li.script_path input').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()
