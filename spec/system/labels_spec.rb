require 'rails_helper'

RSpec.describe 'Label management function', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    visit new_session_path
    fill_in 'Email address', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end

  describe 'Registration function' do
    context 'When a label is registered' do
      it 'Registered labels are displayed.' do
        visit new_label_path
        fill_in 'Name', with: 'Test Label'
        click_button 'register'

        visit labels_path
        expect(page).to have_content 'Test Label'
      end
    end
  end

  describe 'List display function' do
    context 'When transitioning to the list screen' do
      it 'A list of registered labels is displayed.' do
        FactoryBot.create(:label, name: "Label1", user: user)
        FactoryBot.create(:label, name: "Label2", user: user)

        visit labels_path

        expect(page).to have_content 'Label1'
        expect(page).to have_content 'Label2'
      end
    end
  end
end