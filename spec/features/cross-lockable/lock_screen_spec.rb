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
      click_on t('cross_lockable.button')
    end

    visit root_path
    current_path.should eq(root_path)
  end

  context "when there is no password" do
    it "displays error" do
      within('.cross-lockable-screen-box') do
        click_on t('cross_lockable.button')
        page.should have_content(t('cross_lockable.errors.invalid_password'))
      end

      visit root_path
      current_path.should eq(new_user_session_path)
    end
  end

  context "when password is wrong" do
    it "displays error" do
      within('.cross-lockable-screen-box') do
        find('input[type="password"]').set('foo')
        click_on t('cross_lockable.button')
        page.should have_content(t('cross_lockable.errors.invalid_password'))
      end

      visit root_path
      current_path.should eq(new_user_session_path)
    end
  end

  context "when security token is invalid" do
    it "displays error" do
      page.execute_script("$('#token').val('999999999')")

      click_on t('cross_lockable.button')
      page.should have_content(t('cross_lockable.errors.invalid_password'))

      visit root_path
      current_path.should eq(new_user_session_path)
    end
  end
end
