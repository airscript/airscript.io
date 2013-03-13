(function() {

  Airscript.namespace("Airscript.Models", function(Models) {
    Models.Gist = function(id, desc, files) {
      var description, fileName, fileObj, scripts, self;
      if (id == null) {
        id = -1;
      }
      if (desc == null) {
        desc = '';
      }
      if (files == null) {
        files = {};
      }
      id = ko.observable(id);
      description = ko.observable(desc);
      scripts = Models.Scripts();
      for (fileName in files) {
        fileObj = files[fileName];
        scripts.add(fileName, fileObj.content);
      }
      return self = {
        id: id,
        description: description,
        scripts: scripts
      };
    };
    return Models.EMPTY_GIST = Models.Gist();
  });

}).call(this);
