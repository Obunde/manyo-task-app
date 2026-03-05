require 'rails_helper'

RSpec.describe 'Task model function', type: :model do
  # Create a user to associate with tasks
  let!(:user) { FactoryBot.create(:user) }

  describe 'Validation test' do
    it 'is invalid without a title' do
      task = Task.new(title: '', content: 'content', user: user)
      expect(task).not_to be_valid
    end

    it 'is invalid without content' do
      task = Task.new(title: 'title', content: '', user: user)
      expect(task).not_to be_valid
    end

    it 'is invalid without deadline_on' do
      task = Task.new(title: 'title', content: 'content', deadline_on: nil, user: user)
      expect(task).not_to be_valid
    end

    it 'is invalid without priority' do
      task = Task.new(title: 'title', content: 'content', deadline_on: Date.today, priority: nil, user: user)
      expect(task).not_to be_valid
    end

    it 'is invalid without status' do
      task = Task.new(title: 'title', content: 'content', deadline_on: Date.today, priority: :medium, status: nil, user: user)
      expect(task).not_to be_valid
    end

    it 'is valid with title, content, deadline_on, priority, and status present' do
      task = Task.new(
        title: 'title', 
        content: 'content', 
        deadline_on: Date.today, 
        priority: :medium, 
        status: :not_started, 
        user: user
      )
      expect(task).to be_valid
    end
  end

  describe 'Search function' do
    # Create tasks for scope testing
    let!(:task1) { FactoryBot.create(:task, title: 'first_task', deadline_on: Date.today, priority: :medium, status: :not_started, user: user) }
    let!(:task2) { FactoryBot.create(:task, title: 'second_task', deadline_on: Date.today + 1.day, priority: :low, status: :in_progress, user: user) }

    it 'Title is performed by scope method' do
      # Example assuming your scope is named .search_title
      expect(Task.search_title('first')).to include(task1)
      expect(Task.search_title('first')).not_to include(task2)
    end

    it 'When the status is searched with the scope method' do
      # Example assuming your scope is named .search_status
      expect(Task.search_status(:not_started)).to include(task1)
      expect(Task.search_status(:not_started)).not_to include(task2)
    end

    it 'Refine search by Title and status' do
      expect(Task.search_title('first').search_status(:not_started)).to include(task1)
    end
  end
end