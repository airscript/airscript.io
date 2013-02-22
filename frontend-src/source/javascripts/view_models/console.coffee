Airscript.namespace "Airscript.ViewModels", (Models) ->
  Models.Console = ->
    self = this

    self.mode = ko.observable('log')

    self.log = ko.observable('none')
    self.reference = ko.observable('Some dox')

    self.referenceMode = (console, e) ->
      self.mode('reference')

    self.logMode = (console, e) ->
      self.mode('log')

    self.logActive = ->
      self.mode() is 'log'

    self.referenceActive = ->
      self.mode() is 'reference'

    self.logOutput = ->
      self.log()

    self.referenceOutput = ->
      self.reference()

    self
