(function() {

  Airscript.init = function() {
    var ViewModels, editor;
    Airscript.eventBus = new ko.subscribable();
    ViewModels = Airscript.ViewModels;
    editor = new ViewModels.Editor();
    ko.applyBindings(editor, document.querySelector('section.content'));
    ko.applyBindings(editor, document.querySelector('.gist_modal'));
    return $('.gist_modal').modal('show');
  };

}).call(this);
