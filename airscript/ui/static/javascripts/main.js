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
    return ko.applyBindings(editor, document.querySelector('body'));
  };

  $(function() {
    $('input.full_script_path').on('keydown', function(e) {
      if (!(e.metaKey || e.ctrlKey)) {
        if (!(e.keyCode === 67 || e.keyCode === 65)) {
          return e.preventDefault();
        }
      }
    });
    return $('li.script_path, li.script_path input').on('click', function(e) {
      e.preventDefault();
      return e.stopPropagation();
    });
  });

}).call(this);
