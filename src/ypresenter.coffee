class SlideShowUseCase
  constructor: (@presentation, @view, @notesView) ->

  enterPresentation: =>
    @slideIndex = 1
    @notesView.enterPresentation()
    @showSlide()

  nextSlide: =>
    if @slideIndex < @presentation.slidesCount()
      @slideIndex += 1
      @showSlide()

  previousSlide: =>
    if @slideIndex > 1
      @slideIndex -= 1
      @showSlide()

  showSlide: =>
    @view.showSlide(@slideIndex)
    @notesView.showSlide(@slideIndex)

class Presentation
  constructor: (@parent) ->

  slides: =>
    @parent.find("section")

  getSlidesWithout: (index) =>
    result = []
    for slide, slideIndex in @slides()
      if index != slideIndex
        result.push($(slide))
    result

  getSlide: (index) =>
    $(@slides()[index])

  slidesCount: =>
    @slides().length

class MainSlideShowView
  constructor: (@presentation) ->

  showSlide: (index) =>
    index = index - 1
    @presentation.getSlide(index).show()
    for slide in @presentation.getSlidesWithout(index)
      slide.hide()

  bind: (@keyboardController) =>

  wireEvents: (callback) =>
    $(window.document).keydown (e) =>
      @keyDown(e)

  keyDown: (e) =>
    if @keyboardController?
      @keyboardController.keyDown(e)

class NotesView
  constructor: (@presentation) ->

  enterPresentation: =>
    notesWindow = window.open(null, "presentation_notes")
    @notesDocument = $(notesWindow.document)
    @notesBody = @notesDocument.find("body")
    @notesBody.html("<h1>Notes</h1>")
    @notesBody.append("<article></article>")
    @notesRoot = $(@notesBody.find("article"))
    @wireEvents()

  showSlide: (index) =>
    index = index - 1
    @notesRoot.html(@presentation.getSlide(index).find("details").html())

  bind: (@keyboardController) =>

  wireEvents: =>
    @notesDocument.keydown (e) =>
      @keyDown(e)

  keyDown: (e) =>
    if @keyboardController?
      @keyboardController.keyDown(e)

class KeyboardController
  constructor: (@slideShowUseCase) ->

  keyDown: (e) =>
    @handleEvent(e)

  handleEvent: (event) =>
    switch event.keyCode
      when 39
        event.preventDefault()
        @slideShowUseCase.nextSlide()
      when 37
        event.preventDefault()
        @slideShowUseCase.previousSlide()

class YPresenter
  constructor: ->

  setup: =>
    @presentation = new Presentation($("body"))
    @mainSlideShowView = new MainSlideShowView(@presentation)
    @mainSlideShowView.wireEvents()
    @notesView = new NotesView(@presentation)
    @slideShowUseCase = new SlideShowUseCase(@presentation, @mainSlideShowView, @notesView)
    @keyboardController = new KeyboardController(@slideShowUseCase)
    @mainSlideShowView.bind(@keyboardController)
    @notesView.bind(@keyboardController)

  start: =>
    @slideShowUseCase.enterPresentation()

$ ->
  app = new YPresenter()
  app.setup()
  app.start()
