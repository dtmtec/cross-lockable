require 'spec_helper'

describe "Lock screen", js: true do

  let!(:user) { create :user }

  it "logs user with lock screen" do
    visit root_path
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    # page.execute
    debugger
    puts '123'
  end

end