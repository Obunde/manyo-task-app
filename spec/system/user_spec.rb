require 'rails_helper'

RSpec.describe 'User Management Functions', type: :system do
  let!(:user) { FactoryBot.create(:user, name: 'General User', email: 'user@example.com', password: 'password') }
  let!(:admin_user) { FactoryBot.create(:user, :admin, name: 'Admin User', email: 'admin@example.com', password: 'password') }

  before(:each) do
    # Capybara.reset_sessions!  # Clears cookies/session between every test
    user.reload
    admin_user.reload
    visit root_path
  end

  def login_as_user(email, password)
    visit new_session_path
    fill_in I18n.t('sessions.new.email'), with: email
    fill_in I18n.t('common.password'), with: password
    click_button 'create-session'
    expect(page).to have_content(I18n.t('sessions.notice.logged_in'), wait: 5)
  end

  describe 'Registration function' do
    it 'transitions to the task list screen after registration' do
      visit new_user_path
      fill_in I18n.t('common.name'), with: 'New User'
      fill_in I18n.t('common.email'), with: 'new@example.com'
      fill_in I18n.t('common.password'), with: 'password'
      fill_in I18n.t('common.password_confirmation'), with: 'password'
      click_button I18n.t('users.new.submit')
      expect(page).to have_content I18n.t('tasks.index.title')
    end

    it 'redirects to login screen when accessing tasks without logging in' do
      visit tasks_path
      expect(current_path).to eq new_session_path
      expect(page).to have_content I18n.t('sessions.notice.login_required')
    end
  end

  describe 'Login function' do
    it 'successfully logs in and displays the flash message' do
      visit new_session_path
     
      fill_in I18n.t('sessions.new.email'), with: user.email
      fill_in I18n.t('common.password'), with: 'password'
    
      click_button 'create-session'
      
      expect(page).to have_current_path(tasks_path, ignore_query: true)
      expect(page).to have_content I18n.t('sessions.notice.logged_in')
      expect(page).to have_content I18n.t('tasks.index.title')
    end
    context 'when already logged in' do
      before { login_as_user(user.email, 'password') }

      it 'can access its own profile page' do
        visit user_path(user)
        expect(page).to have_content I18n.t('users.show.title')
        expect(page).to have_content user.name
      end

      it "is forbidden from accessing another user's profile" do
        visit user_path(admin_user)
        expect(current_path).to eq tasks_path
        expect(page).to have_content I18n.t('users.notice.forbidden')
      end

      it 'can successfully log out' do
        click_link I18n.t('global.logout')
        expect(current_path).to eq new_session_path
        expect(page).to have_content I18n.t('sessions.notice.logged_out')
      end
    end
  end

  describe 'Administrator function' do
    before { login_as_user(admin_user.email, 'password') }

    it 'can access the user index page' do
      visit admin_users_path
      expect(page).to have_content I18n.t('admin.users.index.title')
    end

    it 'can create a new user via admin panel' do
      visit new_admin_user_path
      fill_in I18n.t('common.name'), with: 'AdminCreated'
      fill_in I18n.t('common.email'), with: 'admincreated@example.com'
      fill_in I18n.t('common.password'), with: 'password'
      fill_in I18n.t('common.password_confirmation'), with: 'password'
      click_button I18n.t('admin.users.form.create')
      expect(page).to have_content 'AdminCreated'
    end

    it 'can access a user details page' do
      visit admin_user_path(user)
      expect(page).to have_content user.name
    end

    it 'can edit users other than themselves' do
      visit edit_admin_user_path(user)
      fill_in I18n.t('common.name'), with: 'UpdatedByAdmin'
      fill_in I18n.t('common.password'), with: 'password'
      fill_in I18n.t('common.password_confirmation'), with: 'password'
      click_button I18n.t('admin.users.form.update')
      expect(page).to have_content 'UpdatedByAdmin'
    end

    it 'can delete a user' do
      visit admin_users_path
      within('tr', text: user.email) do
        click_link I18n.t('common.delete')
      end
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content I18n.t('admin.users.notice.deleted')
    end

    it 'denies general users access to the admin index' do
      click_link I18n.t('global.logout')
      login_as_user(user.email, 'password')
      visit admin_users_path
      expect(current_path).to eq tasks_path
      expect(page).to have_content I18n.t('admin.users.notice.forbidden')
    end
  end
end