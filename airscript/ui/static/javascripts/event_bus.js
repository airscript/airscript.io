(function() {

  Airscript.namespace("Airscript", function(root) {
    return root.eventBus = new ko.subscribable();
  });

}).call(this);
