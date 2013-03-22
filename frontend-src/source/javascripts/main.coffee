ko.bindingHandlers.selected =
  update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
      selected = ko.utils.unwrapObservable(valueAccessor())

      element.select() if (selected)

Airscript.init = ->
  {ViewModels} = Airscript

  editor = new ViewModels.Editor()

  ko.applyBindings editor, document.querySelector('body')

$ ->
  $('input.full_script_path').on 'keydown', (e) ->
    # prevent default unless they are pressing ctrl+c
    unless (e.metaKey || e.ctrlKey)
      unless (e.keyCode is 67 || e.keyCode is 65)
        e.preventDefault()

  $('li.script_path, li.script_path input').on 'click', (e) ->
    e.preventDefault()
    e.stopPropagation()

  # Deploy their engine!
  $('.engine_deploy_spinner, .engine_deploy_curtain').removeClass 'hidden'

  $.ajax
    url: '/api/v1/project/engine/auth'
    type: 'GET'
    success: (data) ->
      {engineKey} = data

      $.ajax
        url: '/api/v1/project/engine'
        type: 'POST'
        data:
          engine_key: engineKey
        success: (a,b,c) ->
          $('.engine_deploy_spinner, .engine_deploy_curtain').addClass 'hidden'
