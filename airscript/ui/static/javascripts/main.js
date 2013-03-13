(function() {

  ko.bindingHandlers.selected = {
    update: function(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) {
      var selected;
      selected = ko.utils.unwrapObservable(valueAccessor());
      if (selected) {
        return element.select();
      }
    }
  };

  Airscript.init = function() {
    var ViewModels, editor;
    ViewModels = Airscript.ViewModels;
    editor = new ViewModels.Editor();
    ko.applyBindings(editor, document.querySelector('body'));
    return $('.gist_modal').modal('show');
  };

  $(function() {
    return new ZeroClipboard(document.querySelector('.clipboard'), {
      moviePath: '/flash/ZeroClipboard.swf'
    });
  });

}).call(this);
