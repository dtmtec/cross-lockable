(function (window, _, Backbone, $) {
  var ScreenView = Backbone.View.extend({

    initialize: function () {
      _(this).bindAll('loaded', 'show', 'onKeypress', 'focus')

      $(window).on('keydown', this.onKeypress)

      this.template = this.$("[data-template-name='cross-lockable-screen']").html()
      this.$box     = this.$('.cross-lockable-screen-box')
      this.iframe   = this.$('iframe').get(0)

      this.origin         = this.$el.data('cross-lockable-origin')
      this.expirationTime = this.$el.data('cross-lockable-expiration-time')

      this.start();
    },

    start: function() {
      this.timeoutId = setTimeout(this.show, this.expirationTime)
    },

    stop: function() {
      clearTimeout(this.timeoutId)
    },

    render: function () {
      this.$box.html(this.template)
      this.$el.addClass('cross-lockable-show')

      _(this.focus).delay(500)
    },

    focus: function () {
      this.$('input[type=password]').focus()
    },

    show: function () {
      $(window).on('message', this.loaded)

      this.render()
      this.stop()
    },

    hide: function () {
      $(window).off('message', this.loaded)

      this.$el.removeClass('cross-lockable-show')
      this.start()
    },

    loaded: function (e) {
      if (this.isValidOrigin(e.originalEvent.origin) && this.isValidSource(e.originalEvent.source)) {
        var data = $.parseJSON(e.originalEvent.data)

        if (data.message == 'success') {
          this.hide()
          this.$el.removeClass('cross-lockable-error')
          this.trigger('cross-lockable:success')

        } else {
          this.$('input[type=password]').val('')
          this.$el.addClass('cross-lockable-error')
          this.trigger('cross-lockable:error')
        }

        $.rails.enableFormElements(this.$('form'))
      }
    },

    isValidOrigin: function (origin) {
      return origin == this.origin
    },

    isValidSource: function (source) {
      return source == this.iframe.contentWindow
    },

    onKeypress: function (e) {
      // ctrl + alt + shift + l
      if (e.ctrlKey && e.shiftKey && e.altKey && e.keyCode == 76) {
        this.show()
      }
    }

  })

  window.CrossLockable = {
    ScreenView: ScreenView
  }

})(window, _, Backbone, jQuery)
