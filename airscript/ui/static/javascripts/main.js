(function() {

  Airscript.init = function() {
    var ViewModels, editor, github, heroku;
    Airscript.eventBus = new ko.subscribable();
    ViewModels = Airscript.ViewModels;
    github = new ViewModels.Github();
    heroku = new ViewModels.Heroku();
    editor = new ViewModels.Editor();
    ko.applyBindings(editor, document.querySelector('section.content'));
    ko.applyBindings(editor, document.querySelector('.gist_modal'));
    ko.applyBindings(github, document.querySelector('.github_modal'));
    return ko.applyBindings(heroku, document.querySelector('.heroku_modal'));
  };

}).call(this);
