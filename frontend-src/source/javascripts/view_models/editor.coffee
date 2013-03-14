Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.Editor = ->
    aceEditor = ace.edit("editor")
    aceEditor.setShowPrintMargin(false)

    aceEditor.on 'change', (e) ->
      value = aceEditor.getSession().getValue()

      scriptsPanel.activeScript().source(value)

    aceEditor.commands.addCommand
      name: 'newScript'
      bindKey:
        win: 'Ctrl-n'
        mac: 'Ctrl-n'
      exec: (editor) ->
        scriptsPanel.createNewFile()
      readOnly: false

    aceEditor.commands.addCommand
      name: 'saveScript'
      bindKey:
        win: 'Ctrl-s'
        mac: 'Ctrl-s'
      exec: (editor) ->
        scriptsPanel.updateGist()
      readOnly: false

    aceEditor.commands.addCommand
      name: 'linkToScript'
      bindKey:
        win: 'Ctrl-l'
        mac: 'Ctrl-l'
      exec: (editor,b,c) ->
        debugger
        $('.link').click()
      readOnly: false

    aceEditor.commands.addCommand
      name: 'editScript'
      bindKey:
        win: 'Ctrl-e'
        mac: 'Ctrl-e'
      exec: (editor) ->
        scriptsPanel.editScript()
      readOnly: false

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

      userName: ->
        cookies = {}

        return unless (cookies = document.cookie.split(';')).length

        for str in cookies
          [key, value] = str.split('=')

          if key && value
            cookies[key.trim()] = value.trim()

        cookies.user || ""

      toggleFullscreen: ->
        $('.edit, .scripts').toggleClass 'fullscreen'
        $('.btn.fullscreen').toggleClass 'active'

        aceEditor.resize()

      selectFullPath: ->
        setTimeout ->
          $('input.full_script_path').select()
        , 1

    aceEditor.commands.addCommand
      name: 'toggleFullscreen'
      bindKey:
        win: 'Ctrl-f'
        mac: 'Ctrl-f'
      exec: (editor) ->
        self.toggleFullscreen()
      readOnly: false

    return self
