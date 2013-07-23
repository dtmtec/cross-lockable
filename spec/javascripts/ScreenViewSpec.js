describe("CrossLockable.ScreenView", function() {
  var view, $element, $box, $iframe, template, called, messageUrl

  beforeEach(function() {
    called = false

    loadFixtures('screen-view.html')

    $element = $('.cross-lockable-screen')
    $box     = $('.cross-lockable-screen .cross-lockable-screen-box')
    $iframe  = $('.cross-lockable-screen iframe')
    template = $('script[data-template-name=cross-lockable-screen]').html()

    messageUrl = 'http://localhost:8888/spec/javascripts/fixtures/success-message.html'
  })

  afterEach(function() {
    $(window).off('message')
  })

  it("should be a Backbone.View", function() {
    view = new CrossLockable.ScreenView({ el: $element })
    expect(view).toBeAnInstanceOf(Backbone.View)
  })

  it("should set the origin based on its data-cross-lockable-origin attribute of the view element", function() {
    view = new CrossLockable.ScreenView({ el: $element })
    expect(view.origin).toEqual($element.data('cross-lockable-origin'))
  })

  it("should set the expiration time based on its data-cross-lockable-expiration-time attribute of the view element", function() {
    view = new CrossLockable.ScreenView({ el: $element })
    expect(view.expirationTime).toEqual($element.data('cross-lockable-expiration-time'))
  })

  it("should call the startExpirationCountdown on the initialize", function() {
    view = new CrossLockable.ScreenView({ el: $element })

    spyOn(view, 'start')
    view.initialize()
    expect(view.start).toHaveBeenCalled()
  })

  describe("when it is rendered", function() {
    beforeEach(function() {
      view = new CrossLockable.ScreenView({ el: $element })
    })

    it("renders screen template inside the box element", function() {
      expect($box).toHaveHtml('')
      view.render()
      expect($box).toHaveHtml(template)
    })
  })

  describe("when the expiration time has passed", function() {
    beforeEach(function(){
      jasmine.Clock.useMock()

      view = new CrossLockable.ScreenView({ el: $element })
      spyOn(view, 'render')
      spyOn(view, 'stop')
    })

    it("opens the lock screen", function() {
      jasmine.Clock.tick(view.expirationTime)
      expect(view.render).toHaveBeenCalled()
    })

    it("clears the expiration time", function() {
      jasmine.Clock.tick(view.expirationTime)
      expect(view.stop).toHaveBeenCalled()
    })
  })

  describe("when the lock screen is closed", function() {
    it("starts the expiration countdown again", function() {
      view = new CrossLockable.ScreenView({ el: $element })
      spyOn(view, 'start')

      view.hide()
      expect(view.start).toHaveBeenCalled()
    })
  })

  describe("when it is shown", function() {
    beforeEach(function() {
      view = new CrossLockable.ScreenView({ el: $element })
    })

    it("renders", function() {
      spyOn(view, 'render')
      view.show()
      expect(view.render).toHaveBeenCalled()
    })

    it("listens to message events on window", function() {
      view.show()
      expect($(window)).toHandleWith('message', view.loaded)
    })

    it("adds .cross-lockable-show class to the element", function() {
      view.show()
      expect($element).toHaveClass('cross-lockable-show')
    })

    describe("and it is hidden", function() {
      beforeEach(function() {
        view = new CrossLockable.ScreenView({ el: $element })
        view.show()
      })

      it("stops listening to message events on window", function() {
        view.hide()
        expect($(window)).not.toHandle('message')
      })

      it("removes .cross-lockable-show class to the element", function() {
        view.hide()
        expect($element).not.toHaveClass('cross-lockable-show')
      })
    })

    describe("and the top window receives a message", function() {
      beforeEach(function() {
        view.show()
      })

      describe("from an unknown origin", function() {
        var loaded

        beforeEach(function() {
          loaded = false
          messageUrl = 'http://127.0.0.1:8888/spec/javascripts/fixtures/success-message.html'

          $iframe.on('load', function () { loaded = true })
        })

        it("does not hides the screen", function() {
          spyOn(view, 'hide')

          $iframe.attr('src', messageUrl)

          waitsFor(function () { return loaded }, 500)

          runs(function () {
            expect(view.hide).not.toHaveBeenCalled()
          })
        })

        it("does not triggers a success event", function() {
          view.on('cross-lockable:success', function () {
            called = true
          })

          $iframe.attr('src', messageUrl)

          waitsFor(function () { return loaded }, 500)

          runs(function() {
            expect(called).toBeFalsy()
          })
        })
      })

      describe("from an invalid source", function() {
        var loaded

        beforeEach(function() {
          $('#jasmine-fixtures').append('<iframe id="invalid-message-iframe"></iframe>')

          $iframe = $('#invalid-message-iframe')
          $iframe.on('load', function () { loaded = true })
        })

        it("does not hides the screen", function() {
          spyOn(view, 'hide')

          $iframe.attr('src', messageUrl)

          waitsFor(function () { return loaded }, 500)

          runs(function () {
            expect(view.hide).not.toHaveBeenCalled()
          })
        })

        it("does not triggers a success event", function() {
          view.on('cross-lockable:success', function () {
            called = true
          })

          $iframe.attr('src', messageUrl)

          waitsFor(function () { return loaded }, 500)

          runs(function() {
            expect(called).toBeFalsy()
          })
        })
      })

      describe("with a valid origin and source", function() {
        describe("and message is success", function() {
          function waitsForSuccess() {
            return !$element.hasClass('cross-lockable-show')
          }

          it("hides the screen", function() {
            spyOn(view, 'hide').andCallThrough()

            $iframe.attr('src', messageUrl)

            waitsFor(waitsForSuccess, 500)

            runs(function() {
              expect(view.hide).toHaveBeenCalled()
            })
          })

          it("triggers a success event", function() {
            view.on('cross-lockable:success', function () {
              called = true
            })

            $iframe.attr('src', messageUrl)

            waitsFor(waitsForSuccess, 500)

            runs(function() {
              expect(called).toBeTruthy()
            })
          })

          it("reenables the form element", function() {
            var $form = $box.find('form')
            $.rails.disableFormElements($form)

            $iframe.attr('src', messageUrl)

            waitsFor(waitsForSuccess, 500)

            runs(function() {
              expect($form.find('input[type=submit]')).not.toBeDisabled()
            })
          })
        })

        describe("and message is not success", function() {
          function waitsForFailure() {
            return $element.hasClass('cross-lockable-error')
          }

          beforeEach(function() {
            messageUrl = 'http://localhost:8888/spec/javascripts/fixtures/invalid-message.html'
          });

          it("does not triggers a success event", function() {
            view.on('cross-lockable:success', function () {
              called = true
            })

            $iframe.attr('src', messageUrl)

            waitsFor(waitsForFailure, 500)

            runs(function() {
              expect(called).toBeFalsy()
            })
          })

          it("triggers an error event", function() {
            view.on('cross-lockable:error', function () {
              called = true
            })

            $iframe.attr('src', messageUrl)

            waitsFor(waitsForFailure, 500)

            runs(function() {
              expect(called).toBeTruthy()
            })
          })

          it("reenables the form element", function() {
            var $form = $box.find('form')
            $.rails.disableFormElements($form)

            $iframe.attr('src', messageUrl)

            waitsFor(waitsForFailure, 500)

            runs(function() {
              expect($form.find('input[type=submit]')).not.toBeDisabled()
            })
          })

          it("cleans value of password input", function() {
            var $form = $box.find('form'),
                $field = $form.find('input[type=password]')

            $field.val('test')
            $iframe.attr('src', messageUrl)

            waitsFor(waitsForFailure, 500)

            runs(function() {
              expect($field.val()).toEqual('')
            })
          })
        })
      })
    })
  })
})
