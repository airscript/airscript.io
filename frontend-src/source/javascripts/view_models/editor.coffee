Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Editor = ->
    @aceEditor = ace.edit("editor")
    @aceEditor.setShowPrintMargin(false)

    Airscript.aceEditor = @aceEditor

    @scriptsView = new Models.Scripts()
    @consoleView = new Models.Console()

    @source = ko.observable('')
    @scriptName = ko.observable('New Script')

    @saveScript = ->
      Airscript.eventBus.notifySubscribers {name: @scriptName(), source: @source()}, 'script:save'

    Airscript.eventBus.subscribe ({source, name}) ->
      @source(source)
      @scriptName(name)
    , @, "editor:updateCode"

    this
