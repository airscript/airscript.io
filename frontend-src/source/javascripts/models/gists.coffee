#= require ./scripts
#= require ./gist

Airscript.namespace "Airscript.Models", (Models) ->
  Models.Gists = ->
    collection = ko.observableArray()

    index = ko.observable(-1)

    self =
      active: ->
        collection()[index()] || Models.EMPTY_GIST

      add: (id, description, files) ->
        collection.push Models.Gist(id, description, files)
        index(collection().length - 1)

      collection: collection

      fetch: ->
        gistsDeferred = $.getJSON '/api/v1/project/target/gists', (data) ->
        gistsDeferred.success (data) ->
          for gist in data
            gist.description = gist.id unless gist.description.length

            # hack
            if gist.description is '# airscript'
              self.add(gist.id, gist.description, gist.files)

              self.target(gist)

        # mock data for dev
        gistsDeferred.error ->
          data = [{
            id: 'dsfasdf323r234'
            description: 'All my Airscripts live in this gist.'
            files: {
              'testing.rb': {
                content: 'some stuff'
              }
            }
          }, {
            id: 'lkasjdf94'
            description: 'This is a script that calls your friends up and plays Rick Astley.'
            files: {
              'testing2.rb': {
                content: 'moar stuff'
              }
            }
          }]

          for gist in data
            gist.description = gist.id unless gist.description.length

            self.add(gist.id, gist.description, gist.files)

      target: (gist, e) ->
        $.ajax
          url: "/api/v1/project/target"
          data:
            type: 'gist'
            id: gist.id
          type: 'PUT'
          success: ->
            # Get ready to go blind
            $.getJSON "/api/v1/project", (data) ->
              gist.files = data.files

              self.active().scripts.update(gist.files)

              # Deploy their engine!
              $('.engine_deploy_spinner, .engine_deploy_curtain').removeClass 'hidden'

              $.ajax
                url: '/api/v1/project/engine/auth'
                type: 'GET'
                success: (data) ->
                  {engine_key, username} = data

                  Airscript.eventBus.notifySubscribers engine_key, 'editor:updateEngineKey'

                  $.ajax
                    url: "/api/v1/project/engine"
                    type: 'POST'
                    data:
                      engine_key: engine_key
                    success: (data) ->
                      Airscript.eventBus.notifySubscribers "#{data.app_name.split('-')[0]}.airscript.io/", 'editor:updateProjectName'

                      $('.engine_deploy_spinner, .engine_deploy_curtain').addClass 'hidden'

      update: ->
        gist = self.active()

        data =
          description: gist.description()
          files: {}

        for file in gist.scripts.collection()
          data.files[file.name()] = {
            fileName: file.name()
            content: file.source() || ""
          }

        $.ajax
          url: '/api/v1/project'
          contentType: 'application/json'
          dataType: 'json'
          type: 'PUT'
          data: JSON.stringify(data)

      select: (idx) ->
        index(idx)

        active = self.active()

      addScript: (name, content) ->
        self.active().scripts.add(name, content)
