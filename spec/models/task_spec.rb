require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'is invalid without a title' do
      task = Task.new(title: nil, content: 'Some content')
      expect(task).not_to be_valid
    end

    it 'is invalid without content' do
      task = Task.new(title: 'Sample title', content: nil)
      expect(task).not_to be_valid
    end

    it 'is valid with both title and content present' do
      task = Task.new(title: 'Sample title', content: 'Sample content')
      expect(task).to be_valid
    end
  end
end
