Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.Editor = ->
    aceEditor = ace.edit("editor")
    aceEditor.setShowPrintMargin(false)

    aceEditor.on 'change', (e) ->
      value = aceEditor.getSession().getValue()

      scriptsPanel.activeScript().source(value)

    scriptsPanel = ViewModels.ScriptsPanel()

    projectName = ko.observable('http://condor.herokuapp.com/')

    Airscript.eventBus.subscribe (name) ->
      projectName(name)
    , null, "editor:updateProjectName"

    self =
      fullScriptPath: ko.computed ->
        "#{projectName()}#{escape(scriptsPanel.activeScript().name())}"

      scriptsPanel: scriptsPanel

      scriptName: ->
        scriptsPanel.activeScript().name()

      scriptSource: ->
        scriptsPanel.activeScript().source()

      scriptEditing: ->
        scriptsPanel.activeScript().editing()
