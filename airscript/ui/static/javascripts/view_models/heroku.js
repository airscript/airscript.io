(function() {

  Airscript.namespace("Airscript.ViewModels", function(Models) {
    return Models.Heroku = function() {
      this.title = ko.observable('');
      this.createProject = function(self, e) {
        var val;
        val = $('.project_name').val();
        self.title(val);
        $('.modal').modal('hide');
        Airscript.eventBus.notifySubscribers(true, 'editMode');
        return Airscript.eventBus.notifySubscribers(self.title(), 'projectName');
      };
      return this;
    };
  });

}).call(this);
