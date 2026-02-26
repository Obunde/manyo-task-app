require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is invalid without a title' do
      task = Task.new(title: nil, content: 'Some content', deadline_on: Date.today, priority: :medium, status: :not_started)
      expect(task).not_to be_valid
    end

    it 'is invalid without content' do
      task = Task.new(title: 'Sample title', content: nil, deadline_on: Date.today, priority: :medium, status: :not_started)
      expect(task).not_to be_valid
    end

    it 'is invalid without deadline_on' do
      task = Task.new(title: 'Sample title', content: 'Sample content', deadline_on: nil, priority: :medium, status: :not_started)
      expect(task).not_to be_valid
    end

    it 'is invalid without priority' do
      task = Task.new(title: 'Sample title', content: 'Sample content', deadline_on: Date.today, priority: nil, status: :not_started)
      expect(task).not_to be_valid
    end

    it 'is invalid without status' do
      task = Task.new(title: 'Sample title', content: 'Sample content', deadline_on: Date.today, priority: :medium, status: nil)
      expect(task).not_to be_valid
    end

    it 'is valid with title, content, deadline_on, priority, and status present' do
      task = Task.new(title: 'Sample title', content: 'Sample content', deadline_on: Date.today, priority: :medium, status: :not_started)
      expect(task).to be_valid
    end
  end
  
  describe 'Search function' do
    # Prepare 3 test data sets based on your table requirements
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', deadline_on: '2022-02-18', priority: :medium, status: :not_started) }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', deadline_on: '2022-02-17', priority: :high, status: :in_progress) }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', deadline_on: '2022-02-16', priority: :low, status: :completed) }

    context 'Title is performed by scope method' do
      it "Tasks containing search words are narrowed down." do
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
      end
    end

    context 'When the status is searched with the scope method' do
      it "Tasks that exactly match the status are narrowed down" do
        expect(Task.search_status(:in_progress)).to include(second_task)
        expect(Task.search_status(:in_progress)).not_to include(first_task)
        expect(Task.search_status(:in_progress)).not_to include(third_task)
        expect(Task.search_status(:in_progress).count).to eq 1
      end
    end

    context 'When performing fuzzy search and status search Title' do
      it "Refine your search to tasks that contain the search word Title and match the status exactly." do
        expect(Task.search_title('third').search_status(:completed)).to include(third_task)
        expect(Task.search_title('third').search_status(:completed)).not_to include(first_task)
        expect(Task.search_title('third').search_status(:completed).count).to eq 1
      end
    end
  end
end
