(function() {

  Airscript.namespace("Airscript.ViewModels", function(Models) {
    return Models.Console = function() {
      var self;
      self = this;
      self.mode = ko.observable('log');
      self.log = ko.observable('none');
      self.reference = ko.observable('Some dox');
      self.referenceMode = function(console, e) {
        return self.mode('reference');
      };
      self.logMode = function(console, e) {
        return self.mode('log');
      };
      self.logActive = function() {
        return self.mode() === 'log';
      };
      self.referenceActive = function() {
        return self.mode() === 'reference';
      };
      self.logOutput = function() {
        return self.log();
      };
      self.referenceOutput = function() {
        return self.reference();
      };
      return self;
    };
  });

}).call(this);
