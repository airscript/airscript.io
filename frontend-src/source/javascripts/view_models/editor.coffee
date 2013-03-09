Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.Editor = ->
    aceEditor = ace.edit("editor")
    aceEditor.setShowPrintMargin(false)

    Airscript.aceEditor = aceEditor

    scriptsPanel = ViewModels.ScriptsPanel()

    projectName = ko.observable('condor.herokuapp.com/')

    source = ko.observable('')
    scriptName = ko.observable('')

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

    Airscript.eventBus.subscribe ({src, name}) ->
      source(src)
      scriptName(name)
    , null, "editor:updateCode"

    Airscript.eventBus.subscribe (name) ->
      projectName(name)
    , null, "editor:updateProjectName"

    return self
