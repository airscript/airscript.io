Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Scripts = ->
    self = this

    self.index = -1

    self.gists = ko.observableArray()
    self.scripts = ko.observableArray()

    self.activeGistDescription = ko.observable('')
    self.activeGist = ko.observable()

    gists = $.getJSON '/api/v1/project/target/gists', (data) ->
    gists.success (data) ->
      for gist in data
        self.gists.push gist

    # mock data for dev
    gists.error ->
      data = [{
        id: 'dsfasdf323r234'
        description: 'test gist'
        files: {
          'testing.rb': {
            raw_url: 'https://gist.github.com/testing.rb'
          }
        }
      }, {
        id: 'lkasjdf94'
        description: 'test gist 2'
        files: {
          'testing2.rb': {
            raw_url: 'https://gist.github.com/testing2.rb'
          }
        }
      }]

      for gist in data
        self.gists.push gist

    activateScript = (index) ->
      activeScript = self.scripts()[index]

      Airscript.eventBus.notifySubscribers {name: activeScript.name(), source: activeScript.source()}, 'editor:updateCode'

    self.createNewFile = ->
      self.scripts.push {
        name: ko.observable('new script')
        source: ko.observable('')
        active: ko.observable(false)
      }

    self.selectGist = (gist, e) ->
      self.scripts([])

      self.activeGist(gist)
      self.activeGistDescription(gist.description || gist.id)

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

    Airscript.eventBus.subscribe (newValue) ->
      self.createNewScript()
    , @, "script:new"

    Airscript.eventBus.subscribe ({name, source}) ->
      script = self.scripts()[self.index]

      script.name(name)
      script.source(source)
    , @, "script:save"

    self
