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

    projectName = ko.observable('')
    engineKey = ko.observable('')

    Airscript.eventBus.subscribe (name) ->
      projectName(name)
    , null, 'editor:updateProjectName'

    Airscript.eventBus.subscribe (key) ->
      engineKey(key)
    , null, "editor:updateEngineKey"

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

      avatarSrc: ->
        cookies = {}

        return unless (cookies = document.cookie.split(';')).length

        for str in cookies
          parts = str.split('=')

          key = parts.shift()
          value = parts.join('=')

          if key && value
            cookies[key.trim()] = value.trim()

        cookies.avatar.replace(/"/g, '') || ""

      userName: ->
        cookies = {}

        return unless (cookies = document.cookie.split(';')).length

        for str in cookies
          [key, value] = str.split('=')

          if key && value
            cookies[key.trim()] = value.trim()

        cookies.user || ""

      isAdmin: ->
        cookies = {}

        return unless (cookies = document.cookie.split(';')).length

        for str in cookies
          [key, value] = str.split('=')

          if key && value
            cookies[key.trim()] = value.trim()

        cookies?.admin is 'true'

      deleteEngine: ->
        console.log engineKey

        if confirm 'Are you sure you want to delete your Airscript engine?'
          $.ajax
            url: "/api/v1/project/engine"
            type: 'DELETE'
            data:
              engine_key: engineKey
            success: (data) ->
              console.log 'deleted!'

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
