Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Scripts = ->
    self = this

    self.index = -1

    self.gists = ko.observableArray()
    self.scripts = ko.observableArray()

    self.activeGist = ko.observable('')

    $.getJSON 'http://localhost:5000/api/v1/project/target/gists', (data) ->
      for gist in data
        self.gists.push gist

    activateScript = (index) ->
      activeScript = self.scripts()[index]

      Airscript.eventBus.notifySubscribers {name: activeScript.name(), source: activeScript.source()}, 'editor:updateCode'

    self.saveScripts = ->
      $.ajax 'http://localhost:5000/api/v1/project/target/gists'
        type: 'POST'
        data:
          description: 'testing'
        success: (data) ->
          console.log data

    self.selectGist = (gist, e) ->
      self.scripts([])

      self.activeGist(gist.description)

      for fileName, fileObj of gist.files
        self.scripts.push {
          name: ko.observable(fileName)
          source: ko.observable(fileObj.contents)
          active: ko.observable(false)
        }

        self.index += 1

      activateScript(self.index)
      $('.modal').modal('hide')

    self.selectScript = (script, e) ->
      self.index = $(e.currentTarget).parent().index()

      for script in self.scripts()
        script.active(false)

      activateScript(self.index)

    self.createNewScript = ->
      for script in self.scripts()
        script.active(false)

      newScript =
        name: ko.observable('New Script')
        source: ko.observable('')
        active: ko.observable(true)

      self.scripts.push newScript

      self.index += 1

      Airscript.eventBus.notifySubscribers {name: newScript.name(), source: newScript.source()}, 'editor:updateCode'

    Airscript.eventBus.subscribe (newValue) ->
      self.createNewScript()
    , @, "script:new"

    Airscript.eventBus.subscribe ({name, source}) ->
      script = self.scripts()[self.index]

      script.name(name)
      script.source(source)
    , @, "script:save"

    self
