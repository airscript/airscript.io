(function() {

  Airscript.init = function() {
    var ViewModels, editor;
    Airscript.eventBus = new ko.subscribable();
    ViewModels = Airscript.ViewModels;
    editor = new ViewModels.Editor();
    ko.applyBindings(editor, document.querySelector('section.content'));
    ko.applyBindings(editor, document.querySelector('.gist_modal'));
    $('.gist_modal').modal('show');
    Airscript.aceEditor.setTheme("ace/theme/github");
    return Airscript.aceEditor.getSession().setMode("ace/mode/lua");
  };

  $(function() {
    var clip;
    return clip = new ZeroClipboard($('.clipboard').get(0), {
      moviePath: '/flash/ZeroClipboard.swf'
    });
  });

}).call(this);
