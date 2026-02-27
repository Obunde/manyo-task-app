require 'rails_helper'

RSpec.describe 'Task management function', type: :system do

  let!(:user) { FactoryBot.create(:user, email: 'taskuser@example.com', password: 'password') }
  let!(:task1) { FactoryBot.create(:task, title: 'first_task', user: user, deadline_on: '2022-02-18', priority: :medium, status: :not_started) }
  let!(:task2) { FactoryBot.create(:task, title: 'second_task', user: user, deadline_on: '2022-02-17', priority: :high, status: :in_progress) }
  let!(:task3) { FactoryBot.create(:task, title: 'third_task', user: user, deadline_on: '2022-02-16', priority: :low, status: :completed) }

  def login
    visit new_session_path
    fill_in I18n.t('sessions.new.email'), with: 'taskuser@example.com'
    fill_in I18n.t('common.password'), with: 'password'
    click_button 'create-session'
    expect(page).to have_content(I18n.t('sessions.notice.logged_in'), wait: 5)
  end

  before { login }

  describe 'Registration function' do
    it 'The registered task is displayed' do
      visit new_task_path
      fill_in 'task_title', with: 'Document preparation'
      fill_in 'task_content', with: 'Create a proposal.'
      fill_in 'task_deadline_on', with: Date.current.since(1.day).to_s
      select I18n.t('tasks.priority.medium'), from: 'task_priority'
      select I18n.t('tasks.status.not_started'), from: 'task_status'
      click_button I18n.t('tasks.new.submit')
      expect(page).to have_content I18n.t('tasks.notice.created')
      expect(page).to have_content 'Document preparation'
    end
  end

  describe 'Task sorting by creation date' do
    let!(:newest_task) do
      create(:task,
             title: 'Newest',
             content: 'Newest content',
             deadline_on: Date.today,
             priority: :medium,
             status: :not_started,
             created_at: Time.zone.now,
             user: user)
    end

    it 'Tasks are displayed in descending order of creation date' do
      visit tasks_path
      first_task_title = page.first('tbody tr td.task-title').text
      expect(first_task_title).to eq 'Newest'
    end
  end

  describe 'Sort function' do
    before { visit tasks_path }

    context 'If you click on the link "Expiration date"' do
      it 'A list of tasks sorted in ascending order of due date is displayed.' do
        click_link I18n.t('tasks.form.deadline')
        sleep 0.5
        expect(page.first('tbody tr td.task-title').text).to eq 'third_task'
      end
    end

    context 'If you click on the link "Priority"' do
      it 'A list of tasks sorted by priority is displayed' do
        click_link I18n.t('tasks.form.priority')
        sleep 0.5
        expect(page.first('tbody tr td.task-title').text).to eq 'second_task'
      end
    end
  end

  describe 'Search function' do
    before { visit tasks_path }

    it 'Only tasks containing the search word will be displayed.' do
      fill_in I18n.t('tasks.form.title'), with: 'first'
      click_button 'Search'
      expect(page).to have_content 'first_task'
      expect(page).not_to have_content 'second_task'
    end

    it 'Only tasks matching the searched status will be displayed' do
      select I18n.t('tasks.status.in_progress'), from: I18n.t('tasks.form.status')
      click_button 'Search'
      expect(page).to have_content 'second_task'
      expect(page).not_to have_content 'first_task'
    end

    it 'Only tasks that contain the search word Title and match the status will be displayed' do
      fill_in I18n.t('tasks.form.title'), with: 'first'
      select I18n.t('tasks.status.not_started'), from: I18n.t('tasks.form.status')
      click_button 'Search'
      expect(page).to have_content 'first_task'
      expect(page).not_to have_content 'second_task'
      expect(page).not_to have_content 'third_task'
    end
  end
end