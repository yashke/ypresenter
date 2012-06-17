// Generated by CoffeeScript 1.3.1
(function() {
  var KeyboardController, MainSlideShowView, Presentation, SlideShowUseCase, YPresenter,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SlideShowUseCase = (function() {

    SlideShowUseCase.name = 'SlideShowUseCase';

    function SlideShowUseCase(presentation, view) {
      this.presentation = presentation;
      this.view = view;
      this.showSlide = __bind(this.showSlide, this);

      this.previousSlide = __bind(this.previousSlide, this);

      this.nextSlide = __bind(this.nextSlide, this);

      this.enterPresentation = __bind(this.enterPresentation, this);

    }

    SlideShowUseCase.prototype.enterPresentation = function() {
      return this.slideIndex = 1;
    };

    SlideShowUseCase.prototype.nextSlide = function() {
      if (this.slideIndex < this.presentation.slidesCount()) {
        this.slideIndex += 1;
        return this.showSlide();
      }
    };

    SlideShowUseCase.prototype.previousSlide = function() {
      if (this.slideIndex > 1) {
        this.slideIndex -= 1;
        return this.showSlide();
      }
    };

    SlideShowUseCase.prototype.showSlide = function() {
      return this.view.showSlide(this.slideIndex);
    };

    return SlideShowUseCase;

  })();

  Presentation = (function() {

    Presentation.name = 'Presentation';

    function Presentation(parent) {
      this.parent = parent;
      this.slidesCount = __bind(this.slidesCount, this);

      this.getSlide = __bind(this.getSlide, this);

      this.getSlidesWithout = __bind(this.getSlidesWithout, this);

      this.slides = __bind(this.slides, this);

    }

    Presentation.prototype.slides = function() {
      return this.parent.find("section");
    };

    Presentation.prototype.getSlidesWithout = function(index) {
      var result, slide, slideIndex, _i, _len, _ref;
      result = [];
      _ref = this.slides();
      for (slideIndex = _i = 0, _len = _ref.length; _i < _len; slideIndex = ++_i) {
        slide = _ref[slideIndex];
        if (index !== slideIndex) {
          result.push($(slide));
        }
      }
      return result;
    };

    Presentation.prototype.getSlide = function(index) {
      return $(this.slides()[index]);
    };

    Presentation.prototype.slidesCount = function() {
      return this.slides().length;
    };

    return Presentation;

  })();

  MainSlideShowView = (function() {

    MainSlideShowView.name = 'MainSlideShowView';

    function MainSlideShowView(presentation) {
      this.presentation = presentation;
      this.showSlide = __bind(this.showSlide, this);

    }

    MainSlideShowView.prototype.showSlide = function(index) {
      var slide, _i, _len, _ref, _results;
      index = index - 1;
      this.presentation.getSlide(index).show();
      _ref = this.presentation.getSlidesWithout(index);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        slide = _ref[_i];
        _results.push(slide.hide());
      }
      return _results;
    };

    return MainSlideShowView;

  })();

  KeyboardController = (function() {

    KeyboardController.name = 'KeyboardController';

    function KeyboardController(slideShowUseCase) {
      this.slideShowUseCase = slideShowUseCase;
      this.handleEvent = __bind(this.handleEvent, this);

      this.wireEvents = __bind(this.wireEvents, this);

    }

    KeyboardController.prototype.wireEvents = function() {
      var _this = this;
      return $(document).keydown(function(e) {
        return _this.handleEvent(e);
      });
    };

    KeyboardController.prototype.handleEvent = function(event) {
      switch (event.keyCode) {
        case 39:
          event.preventDefault();
          return this.slideShowUseCase.nextSlide();
        case 37:
          event.preventDefault();
          return this.slideShowUseCase.previousSlide();
      }
    };

    return KeyboardController;

  })();

  YPresenter = (function() {

    YPresenter.name = 'YPresenter';

    function YPresenter() {
      this.start = __bind(this.start, this);

      this.setup = __bind(this.setup, this);

    }

    YPresenter.prototype.setup = function() {
      this.presentation = new Presentation($("body"));
      this.mainSlideShowView = new MainSlideShowView(this.presentation);
      this.slideShowUsecase = new SlideShowUseCase(this.presentation, this.mainSlideShowView);
      this.keyboardController = new KeyboardController(this.slideShowUsecase);
      return this.keyboardController.wireEvents();
    };

    YPresenter.prototype.start = function() {
      return this.slideShowUsecase.enterPresentation();
    };

    return YPresenter;

  })();

  $(function() {
    var app;
    app = new YPresenter();
    app.setup();
    return app.start();
  });

}).call(this);