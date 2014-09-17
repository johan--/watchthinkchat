require 'spec_helper'

describe 'User' do
  before do
    Capybara.app_host = "http://#{ENV['dashboard_url']}"
  end
  describe 'registration' do
    feature 'create a new user' do
      scenario 'email and password' do
        expect do
          visit root_path
          click_link 'Sign Up'
          user = attributes_for(:user)
          fill_in 'user[first_name]', with: user[:first_name]
          fill_in 'user[last_name]', with: user[:last_name]
          fill_in 'user[email]', with:  user[:email]
          fill_in 'user[password]', with:  user[:password]
          fill_in 'user[password_confirmation]', with:  user[:password]
          click_button 'Sign up'
        end.to change(User, :count).by(1)
        expect(current_path).to eq(authenticated_root_path)
      end
      scenario 'facebook' do
        user = attributes_for(:user)
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:facebook] =
          OmniAuth::AuthHash.new(provider: 'facebook',
                                 uid: '123545',
                                 info: {
                                   email: user[:email],
                                   first_name: user[:first_name],
                                   last_name: user[:last_name],
                                   image: Faker::Company.logo
                                 }
                                )
        expect do
          visit root_path
          click_link 'Sign Up'
          find("a[href='#{user_omniauth_authorize_path(:facebook)}']").click
        end.to change(User, :count).by(1)
        expect(current_path).to eq(authenticated_root_path)
      end
    end
  end
  describe 'sign in' do
    feature 'authenticate existing user' do
      scenario 'email and password' do
        user_attributes = attributes_for(:user)
        user = User.new(user_attributes)
        user.roles << :manager
        user.save

        visit root_path
        fill_in 'user[email]', with:  user_attributes[:email]
        fill_in 'user[password]', with:  user_attributes[:password]
        click_button 'Sign in'
        expect(current_path).to eq(authenticated_root_path)
      end
    end
  end
end
