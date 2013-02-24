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
        description: ''
        files: {
          'testing.rb': {
            raw_url: 'https://gist.github.com/mdiebolt/f0db8fa554857aadffc7/raw/a2922c91fe1cae360ec2d2ca6240cb21516618dc/access_to_sketch.rb'
          }
        }
      }, {
        id: 'lkasjdf94'
        description: 'test gist 2'
        files: {
          'testing2.rb': {
            raw_url: 'https://gist.github.com/mdiebolt/f0db8fa554857aadffc7/raw/a2922c91fe1cae360ec2d2ca6240cb21516618dc/access_to_sketch.rb'
          }
        }
      }]

      for gist in data
        gist.description = gist.id unless gist.description.length

        self.gists.push gist

    activateScript = (index) ->
      activeScript = self.scripts()[index]

      Airscript.eventBus.notifySubscribers {
        name: activeScript.name()
        source: activeScript.source()
      }, 'editor:updateCode'

    self.createNewFile = ->
      self.scripts.push {
        name: ko.observable('new script')
        source: ko.observable('')
      }

      self.index += 1

      activateScript(self.index)

    self.selectGist = (gist, e) ->
      self.scripts([])
      self.index = -1

      self.activeGist(gist)
      self.activeGistDescription(gist.description)

      for fileName, fileObj of gist.files
        $.getJSON fileObj.raw_url, (data) ->
          self.scripts.push {
            name: ko.observable(fileName)
            source: ko.observable(data)
          }

          self.index += 1

          activateScript(self.index)
      
      $('.modal').modal('hide')

    self.selectScript = (script, e) ->
      self.index = $(e.currentTarget).parent().index()

      activateScript(self.index)

    Airscript.eventBus.subscribe (newValue) ->
      self.createNewScript()
    , @, "script:new"

    Airscript.eventBus.subscribe ({name, source}) ->
      script = self.scripts()[self.index]

      script.source(source)
    , @, "script:save"

    self
