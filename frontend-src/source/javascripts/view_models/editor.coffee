Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Editor = ->
    self = @

    @aceEditor = ace.edit("editor")
    @aceEditor.setShowPrintMargin(false)

    Airscript.aceEditor = @aceEditor

    @scriptsView = new Models.Scripts()
    @consoleView = new Models.Console()

    @projectName = ko.observable('pyConRussia.herokuapp.com')

    @source = ko.observable('')
    @scriptName = ko.observable('New Script')

    @fullScriptUrl = ko.computed ->
      "http://#{self.projectName()}/#{self.scriptsView.activeScriptName()}"

    @fullScriptPath = ko.computed ->
      "#{self.projectName()}/#{self.scriptsView.activeScriptName()}"

    @saveScript = ->
      Airscript.eventBus.notifySubscribers {name: @scriptName(), source: @source()}, 'script:save'

    Airscript.eventBus.subscribe ({source, name}) ->
      @source(source)
      @scriptName(name)
    , @, "editor:updateCode"

    this
