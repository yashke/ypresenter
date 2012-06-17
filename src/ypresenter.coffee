class SlideShowUseCase
  constructor: (@presentation, @view) ->

  enterPresentation: =>
    @slideIndex = 1

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

class KeyboardController
  constructor: (@slideShowUseCase) ->

  wireEvents: =>
    $(document).keydown (e) =>
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
    @slideShowUsecase = new SlideShowUseCase(@presentation, @mainSlideShowView)
    @keyboardController = new KeyboardController(@slideShowUsecase)
    @keyboardController.wireEvents()

  start: =>
    @slideShowUsecase.enterPresentation()

$ ->
  app = new YPresenter()
  app.setup()
  app.start()
