require 'spec_helper'

describe "Lock screen", js: true do

  let!(:user) { create :user }

  it "logs user with lock screen" do
    visit root_path

    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    page.execute_script("CrossLockable.screenView.show()")

    within('.cross-lockable-screen-box') do
      find('input[type="text"]').set(user.password)
      click_on 'Entrar'
    end

    visit root_path
    current_path.should eq(root_path)
  end

end