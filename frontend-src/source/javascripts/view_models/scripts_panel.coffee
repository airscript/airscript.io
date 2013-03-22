#= require ../models/gists

Airscript.namespace "Airscript.ViewModels", (ViewModels) ->
  ViewModels.ScriptsPanel = ->
    gists = Airscript.Models.Gists()
    gists.fetch()

    firstScript = ->
      gists.active().scripts.collection()[0]

    self =
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
        $('.file .edit_script').width($('.file .name').width())

        gists.active().scripts.edit(self.activeScript())

      deleteScript: (editor, e) ->
        if confirm "Are you sure you want to delete this script?"
          # delete the file from GitHub
          gist = gists.active()

          data =
            description: gist.description()
            files: {}

          for file in gist.scripts.collection()
            if editor.scriptName() is file.name()
              data.files[file.name()] = null
            else
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

          # Remove the file locally
          gist.scripts.delete(self.activeScript())

      hasScripts: ->
        gists.active().scripts.collection().length > 0

      files: ->
        gists.active().scripts.collection

      updateGist: ->
        gists.update()
