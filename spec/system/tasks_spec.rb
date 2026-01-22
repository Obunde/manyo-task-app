require 'rails_helper'

RSpec.describe 'Task management', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'Task creation' do
    it 'displays the created task' do
      visit new_task_path

      fill_in 'Title', with: 'My First Task'
      fill_in 'Content', with: 'This is a test task'
      click_button 'Create Task'

      expect(page).to have_content 'Task was successfully created.'
      expect(page).to have_content 'My First Task'
      expect(page).to have_content 'This is a test task'
    end
  end

  describe 'Task list' do
    it 'shows registered tasks' do
      task = FactoryBot.create(:task, title: 'Listed Task')

      visit tasks_path

      expect(page).to have_content 'Listed Task'
    end
  end

  describe 'Task detail' do
    it 'shows correct task details' do
      task = FactoryBot.create(
        :task,
        title: 'Detail Task',
        content: 'Detail Content'
      )

      visit task_path(task)

      expect(page).to have_content 'Detail Task'
      expect(page).to have_content 'Detail Content'
    end
  end
end
