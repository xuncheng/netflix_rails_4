require 'spec_helper'

feature "User resets password" do
  after { ActionMailer::Base.deliveries.clear }

  scenario "user successfully resets the password" do
    alice = FactoryGirl.create(:user, password: "old_password", password_confirmation: "old_password")

    visit sign_in_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: alice.email
    click_button "Send Email"

    open_email(alice.email)
    current_email.click_link("Reset Password")

    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: alice.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"

    expect(page).to have_content("Welcome, #{alice.full_name}")
  end
end
