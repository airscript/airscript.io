#= require ./scripts

Airscript.namespace "Airscript.Models", (Models) ->
  Models.Gists = ->
    collection = ko.observableArray()
    scripts = Models.Scripts()

    index = ko.observable(-1)

    {
      active: ko.computed ->
        collection()[index]

      collection: collection

      fetch: ->
        gistsDeferred = $.getJSON '/api/v1/project/target/gists', (data) ->
        gistsDeferred.success (data) ->
          for gist in data
            gist.description = gist.id unless gist.description.length

            self.gists.push gist

        # mock data for dev
        gistsDeferred.error ->
          data = [{
            id: 'dsfasdf323r234'
            description: ''
            files: {
              'testing.rb': {
                content: 'some stuff'
              }
            }
          }, {
            id: 'lkasjdf94'
            description: 'test gist 2'
            files: {
              'testing2.rb': {
                content: 'moar stuff'
              }
            }
          }]

          for gist in data
            gist.description = gist.id unless gist.description.length

            collection.push gist

      target: (gist, e) ->
        $.ajax
          url: "/api/v1/project/target"
          data:
            type: 'gist'
            id: gist.id
          type: 'PUT'
          success: ->
            $.getJSON "/api/v1/project", (data) ->
              Airscript.eventBus.notifySubscribers data.config.engine_url, 'editor:updateProjectName'

              gist.files = data.files

              scripts.empty()

              self.activeGist(gist)
              self.activeGistDescription(gist.description)

              for fileName, fileObj of gist.files
                scripts.add(fileName, fileObj.content)

        $('.modal').modal('hide')

      update: ->
        gist = self.activeGist()

        data =
          description: gist.description
          files: {}

        for file in self.scripts()
          data.files[file.name()] = {
            fileName: file.name()
            content: file.source() || ""
          }

        $.ajax
          url: '/api/v1/project'
          type: 'PUT'
          data: data
          success: ->
            console.log 'woo'

      addScript: (name, content) ->
        scripts.add(name, content)

      editScript: (index) ->
        scripts.edit(index)

      selectScript: (index) ->
        scripts.select(index)
    }
