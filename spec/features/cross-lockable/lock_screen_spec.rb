require 'spec_helper'

describe "Lock screen", js: true do
  let!(:user) { create :user }

  before do
    visit root_path

    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    page.execute_script("CrossLockable.screenView.show()")
  end

  it "logs user with lock screen" do
    within('.cross-lockable-screen-box') do
      find('input[type="password"]').set(user.password)
      click_on 'Entrar'
    end

    visit root_path
    current_path.should eq(root_path)
  end

  it "displays error when there is no password" do
    within('.cross-lockable-screen-box') do
      click_on 'Entrar'
      page.should have_content(I18n.t('lock_screen.errors.invalid_password'))
    end

    visit root_path
    current_path.should eq(new_user_session_path)
  end

  it "displays error when there is no password" do
    within('.cross-lockable-screen-box') do
      find('input[type="password"]').set('foo')
      click_on 'Entrar'
      page.should have_content(I18n.t('lock_screen.errors.invalid_password'))
    end

    visit root_path
    current_path.should eq(new_user_session_path)
  end
end
