(function() {

  Airscript.namespace("Airscript.ViewModels", function(Models) {
    return Models.Github = function() {
      this.name = ko.observable(null);
      this.loggedIn = ko.observable(false);
      this.title = ko.observable('');
      this.createProject = function(self, e) {
        var github, password, projectName, username;
        projectName = $('.project_name').val();
        username = $('.github_modal .username').val();
        password = $('.github_modal .password').val();
        if (username.length && password.length) {
          $('.modal').modal('hide');
          github = new Github({
            username: username,
            password: password,
            auth: "basic"
          });
          this.name(username);
          this.loggedIn(true);
          self.title(projectName);
          Airscript.eventBus.notifySubscribers(true, 'editMode');
          return Airscript.eventBus.notifySubscribers(self.title(), 'projectName');
        }
      };
      this.logout = function() {
        return this.loggedIn(false);
      };
      return this;
    };
  });

}).call(this);
