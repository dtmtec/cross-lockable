$(function () {
  $('.cross-lockable-screen').each(function () {
    CrossLockable.screenView = new CrossLockable.ScreenView({ el: this })
    CrossLockable.screenView.$el.removeClass('hide')
  })
})
