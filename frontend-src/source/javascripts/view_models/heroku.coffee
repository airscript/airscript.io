Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Heroku = ->
    @title = ko.observable('')

    @createProject = (self, e) ->
      val = $('.project_name').val()

      self.title(val)

      $('.modal').modal('hide')

      Airscript.eventBus.notifySubscribers true, 'editMode'
      Airscript.eventBus.notifySubscribers self.title(), 'projectName'

    this
