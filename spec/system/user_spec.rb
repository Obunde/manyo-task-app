require 'rails_helper'

RSpec.describe 'User Management Functions', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:user, admin: true) }

  describe 'Registration function' do
    context 'When a user is registered' do
      it 'Transition to the task list screen' do
        visit new_user_path
        fill_in I18n.t('common.name'), with: 'New User'
        fill_in I18n.t('common.email'), with: 'new@example.com'
        fill_in I18n.t('common.password'), with: 'password'
        fill_in I18n.t('common.password_confirmation'), with: 'password'
        click_button I18n.t('users.new.submit')
        expect(page).to have_content I18n.t('tasks.index.title')
      end
    end

    context 'When you move to the Task List screen without logging in' do
      it 'Redirected to login screen and displays "Please log in"' do
        visit tasks_path
        expect(page).to have_content I18n.t('sessions.notice.login_required')
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe 'Login function' do
    before do
      user.update!(password: 'password', password_confirmation: 'password')
      visit new_session_path
      fill_in I18n.t('sessions.new.email'), with: user.email
      fill_in I18n.t('common.password'), with: 'password'
      click_button I18n.t('sessions.new.submit')
    end

    context 'When logged in as a registered user' do
      it 'Displays "I have logged in"' do
        if page.has_field?(I18n.t('sessions.new.email'))
          fill_in I18n.t('sessions.new.email'), with: user.email
          fill_in I18n.t('common.password'), with: 'password'
          click_button I18n.t('sessions.new.submit')
        end

        expect(page).to have_content I18n.t('tasks.index.title')
      end

      it 'Access to your own detail screen' do
        visit user_path(user)
        expect(page).to have_content I18n.t('users.show.title')
        expect(page).to have_content user.name
      end

      it "Accessing someone else's detail screen redirects to task list" do
        visit user_path(admin_user)
        expect(current_path).to eq tasks_path
        expect(page).to have_content I18n.t('users.notice.forbidden')
      end

      it 'Logging out redirects to login screen' do
        click_link I18n.t('global.logout')
        expect(page).to have_content I18n.t('sessions.notice.logged_out')
        expect(current_path).to eq new_session_path
      end
    end
  end

  describe 'Administrator function' do
    before do
      visit new_session_path
      fill_in I18n.t('sessions.new.email'), with: admin_user.email
      fill_in I18n.t('common.password'), with: 'password'
      click_button I18n.t('sessions.new.submit')
    end

    context 'When the administrator logs in' do
      it 'Access to the user list screen' do
        visit admin_users_path
        expect(page).to have_content I18n.t('admin.users.index.title')
      end

      it 'Can register users' do
        visit new_admin_user_path
        fill_in I18n.t('common.name'), with: 'AdminCreated'
        fill_in I18n.t('common.email'), with: 'admincreated@example.com'
        fill_in I18n.t('common.password'), with: 'password'
        fill_in I18n.t('common.password_confirmation'), with: 'password'
        click_button I18n.t('admin.users.form.create')
        expect(page).to have_content 'AdminCreated'
      end

      it 'Access to user details screen' do
        visit admin_user_path(user)
        expect(page).to have_content user.name
      end

      it 'Edit users other than yourself' do
        visit edit_admin_user_path(user)
        fill_in I18n.t('common.name'), with: 'UpdatedByAdmin'
        fill_in I18n.t('common.password'), with: 'password'
        fill_in I18n.t('common.password_confirmation'), with: 'password'
        click_button I18n.t('admin.users.form.update')
        expect(page).to have_content 'UpdatedByAdmin'
      end

      it 'Users can be deleted' do
        visit admin_users_path
        within('tr', text: I18n.t('admin.users.index.admin_no')) do
          click_link I18n.t('common.delete')
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content I18n.t('admin.users.notice.deleted')
      end
    end

    context 'When a general user accesses the User List screen' do
      it 'Redirects to tasks with error message' do
        click_link I18n.t('global.logout')
        # Log in as general user
        visit new_session_path
        fill_in I18n.t('sessions.new.email'), with: user.email
        fill_in I18n.t('common.password'), with: 'password'
        click_button I18n.t('sessions.new.submit')
        
        visit admin_users_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content I18n.t('admin.users.notice.forbidden')
      end
    end
  end
end