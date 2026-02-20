require 'rails_helper'

RSpec.describe 'Task management function', type: :system do

  describe 'Registration function' do
    context 'When registering a task' do
      it 'The registered task is displayed' do
        visit new_task_path

        fill_in 'Title', with: 'Document preparation'
        fill_in 'Content', with: 'Create a proposal.'

        click_button 'Create Task'

        expect(page).to have_content 'Task was successfully created.'
        expect(page).to have_content 'Document preparation'
        expect(page).to have_content 'Create a proposal.'
      end
    end
  end

  describe 'List display function' do
    context 'Basic list display' do
      it 'A list of registered tasks is displayed' do
        create(:task, title: 'Document preparation')

        visit tasks_path

        expect(page).to have_content 'Document preparation'
      end
    end
  end

  describe 'Detailed display function' do
    context 'When transitioned to any task details screen' do
      it 'The content of the task is displayed' do
        task = create(:task)

        visit task_path(task)

        expect(page).to have_content task.title
        expect(page).to have_content task.content
      end
    end
  end

  describe 'Task sorting by creation date' do
    # Create test data with different creation times
    let!(:first_task) do
      create(
        :task,
        title: 'first_task',
        created_at: Time.zone.parse('2022-02-18 10:00')
      )
    end

    let!(:second_task) do
      create(
        :task,
        title: 'second_task',
        created_at: Time.zone.parse('2022-02-17 10:00')
      )
    end

    let!(:third_task) do
      create(
        :task,
        title: 'third_task',
        created_at: Time.zone.parse('2022-02-16 10:00')
      )
    end

    before do
      visit tasks_path
    end

    context 'When transitioning to the list screen' do
      it 'Tasks are displayed in descending order of creation date' do
        task_rows = all('tbody tr')

        expect(task_rows[0]).to have_content 'first_task'
        expect(task_rows[1]).to have_content 'second_task'
        expect(task_rows[2]).to have_content 'third_task'
      end
    end

    context 'When creating a new task' do
      it 'New task is displayed at the top of the list' do
        click_link 'New Task'

        fill_in 'Title', with: 'new_task'
        fill_in 'Content', with: 'new content'
        click_button 'Create Task'

        task_rows = all('tbody tr')
        expect(task_rows[0]).to have_content 'new_task'
      end
    end
  end
end
