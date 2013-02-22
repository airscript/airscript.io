Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Github = ->
    @name = ko.observable(null)
    @loggedIn = ko.observable(false)
    @title = ko.observable('')

    @createProject = (self, e) ->
      projectName = $('.project_name').val()
      username = $('.github_modal .username').val()
      password = $('.github_modal .password').val()

      if username.length && password.length
        $('.modal').modal('hide')

        github = new Github
          username: username
          password: password
          auth: "basic"

        @name(username)
        @loggedIn(true)

        self.title(projectName)

        Airscript.eventBus.notifySubscribers true, 'editMode'
        Airscript.eventBus.notifySubscribers self.title(), 'projectName'

    @logout = ->
      @loggedIn(false)

    this
