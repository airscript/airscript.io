Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.Editor = ->
    aceEditor = ace.edit("editor")
    aceEditor.setShowPrintMargin(false)

    Airscript.aceEditor = aceEditor

    scriptsPanel = ViewModels.ScriptsPanel()

    projectName = ko.observable('')

    source = ko.observable('')
    scriptName = ko.observable('')

    Airscript.eventBus.subscribe ({source, name}) ->
      @source(source)
      @scriptName(name)
    , @, "editor:updateCode"

    Airscript.eventBus.subscribe (name) ->
      @projectName(name)
    , @, "editor:updateProjectName"

    self =
      fullScriptPath: ko.computed ->
        "#{projectName()}#{scriptName()}"

      saveScript: ->
        Airscript.eventBus.notifySubscribers
          name: scriptName()
          source: source()
        , 'script:save'

      scriptsPanel: scriptsPanel

      source: source
