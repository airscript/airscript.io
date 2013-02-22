Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Editor = ->
    @aceEditor = ace.edit("editor")
    @aceEditor.setShowPrintMargin(false)

    @scriptsView = new Models.Scripts()
    @consoleView = new Models.Console()
    @navbarView = new Models.Github()

    @source = ko.observable('')
    @scriptName = ko.observable('New Script')

    @editMode = ko.observable(false)
    @projectName = ko.observable('New Project')

    @saveScript = ->
      Airscript.eventBus.notifySubscribers {name: @scriptName(), source: @source()}, 'script:save'

    Airscript.eventBus.subscribe (script) ->
      @source(script.source)
      @scriptName(script.name)
    , @, "editor:updateCode"

    Airscript.eventBus.subscribe (newValue) ->
      @editMode(newValue)
      @aceEditor.setTheme("ace/theme/github")
      @aceEditor.getSession().setMode("ace/mode/lua")
      @aceEditor.resize(true)
      $('.gist_modal').modal('show')
    , @, "editMode"

    Airscript.eventBus.subscribe (newValue) ->
      @projectName(newValue)
    , @, "projectName"

    this
