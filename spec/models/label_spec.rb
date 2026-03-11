require 'rails_helper'

RSpec.describe 'Label Model Function', type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'Validation test' do

    context 'If the label name is an empty string' do
      it 'Validation fails' do
        label = Label.new(name: '', user: user)
        expect(label).not_to be_valid
      end
    end

    context 'If the label name has a value' do
      it 'Validation Succeeds' do
        label = Label.new(name: 'Work', user: user)
        expect(label).to be_valid
      end
    end

  end
end