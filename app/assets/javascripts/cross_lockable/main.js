(function (window, _, Backbone, $) {

  var ScreenView = Backbone.View.extend({

    initialize: function () {
      _(this).bindAll('loaded')

      this.template = this.$("[data-template-name='cross-lockable-screen']").html()
      this.$box     = this.$('.cross-lockable-screen-box')
      this.iframe   = this.$('iframe').get(0)

      this.origin   = this.$el.data('cross-lockable-origin')
    },

    render: function () {
      this.$box.html(this.template)
    },

    show: function () {
      this.render()

      $(window).on('message', this.loaded)
      this.$el.addClass('cross-lockable-show')
    },

    hide: function () {
      $(window).off('message', this.loaded)
      this.$el.removeClass('cross-lockable-show')
    },

    loaded: function (e) {
      if (this.isValidOrigin(e.originalEvent.origin) && this.isValidSource(e.originalEvent.source)) {
        var data = $.parseJSON(e.originalEvent.data)

        if (data.message == 'success') {
          this.hide()
          this.trigger('cross-lockable:success')
        } else {
          this.$el.addClass('cross-lockable-error')
          this.$el.find('.control-group.password').addClass('error')
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
    }
  })

  window.CrossLockable = {
    ScreenView: ScreenView
  }

})(window, _, Backbone, jQuery)
