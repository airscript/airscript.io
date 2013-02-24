Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Editor = ->
    self = @

    @aceEditor = ace.edit("editor")
    @aceEditor.setShowPrintMargin(false)

    Airscript.aceEditor = @aceEditor

    @scriptsView = new Models.Scripts()
    @consoleView = new Models.Console()

    @projectName = ko.observable('')

    @source = ko.observable('')
    @scriptName = ko.observable('')

    @fullScriptUrl = ko.computed ->
      "http://#{self.projectName()}/#{self.scriptName()}"

    @fullScriptPath = ko.computed ->
      "#{self.projectName()}/#{self.scriptName()}"

    @saveScript = ->
      Airscript.eventBus.notifySubscribers {name: @scriptName(), source: @source()}, 'script:save'

    Airscript.eventBus.subscribe ({source, name}) ->
      @source(source)
      @scriptName(name)
    , @, "editor:updateCode"

    Airscript.eventBus.subscribe (name) ->
      @projectName(name)
    , @, "editor:updateProjectName"

    this
