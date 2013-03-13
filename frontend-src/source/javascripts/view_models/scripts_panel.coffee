#= require ../models/gists

Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.ScriptsPanel = ->
    gists = Airscript.Models.Gists()
    gists.fetch()

    firstScript = ->
      gists.active().scripts.collection()[0]

    self =
      activeGistDescription: ->
        gists.active()?.description() || ''

      activeScript: ->
        gists.active()?.scripts.active()

      stopEditing: (self, e) ->
        if e.keyCode is 13
          value = $(e.currentTarget).val()

          gists.active().scripts.stopEditing(value)
        else
          true

      createNewFile: ->
        gists.active().scripts.add('new script', '')

      selectScript: (script, e) ->
        gists.active().scripts.select(script)

      editScript: (script, e) ->
        gists.active().scripts.edit(self.activeScript())

      deleteScript: (script, e) ->
        gists.active().scripts.delete(self.activeScript())

      hasGists: ->
        gists.hasGists()

      hasScripts: ->
        gists.active().scripts.collection().length > 0

      files: ->
        gists.active().scripts.collection

      updateGist: ->
        gists.update()

      gistsList: ->
        gists.collection

      selectGist: (gist, e) ->
        index = $(e.currentTarget).index()

        gists.select(index)

        activeGist = gists.active()

        gists.target(activeGist)

        self.selectScript(firstScript())
