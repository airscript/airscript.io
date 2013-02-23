Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Editor = ->
    @aceEditor = ace.edit("editor")
    @aceEditor.setShowPrintMargin(false)
    @aceEditor.setTheme("ace/theme/github")
    @aceEditor.getSession().setMode("ace/mode/lua")

    @scriptsView = new Models.Scripts()
    @consoleView = new Models.Console()

    @source = ko.observable('')
    @scriptName = ko.observable('New Script')

    @projectName = ko.observable('New Project')

    @saveScript = ->
      Airscript.eventBus.notifySubscribers {name: @scriptName(), source: @source()}, 'script:save'

    Airscript.eventBus.subscribe (script) ->
      @source(script.source)
      @scriptName(script.name)
    , @, "editor:updateCode"

    Airscript.eventBus.subscribe (newValue) ->
      @projectName(newValue)
    , @, "projectName"

    this
