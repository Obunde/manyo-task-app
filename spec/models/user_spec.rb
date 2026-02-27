require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validation test' do

    it 'is valid with name, unique email, and password >= 6 characters' do
      user = User.new(
        name: 'Valid User',
        email: 'valid@example.com',
        password: 'password',
      )
      expect(user).to be_valid
    end
    it 'is invalid if the name is empty' do
      user = User.new(name: '', email: 'test@example.com', password: 'password')
      expect(user).not_to be_valid
    end

    it 'is invalid if the email is empty' do
      user = User.new(name: 'Test User', email: '', password: 'password')
      expect(user).not_to be_valid
    end

    it 'is invalid if the email address is already taken' do
      FactoryBot.create(:user, email: 'duplicate@example.com')
      user = User.new(name: 'New User', email: 'duplicate@example.com', password: 'password')
      expect(user).not_to be_valid
    end

    it 'is invalid if the password is empty' do
      user = User.new(name: 'Test User', email: 'test@example.com', password: '')
      expect(user).not_to be_valid
    end

    it 'is invalid if the password is less than 6 characters' do
      user = User.new(name: 'Test User', email: 'test@example.com', password: '12345')
      expect(user).not_to be_valid
    end
  end

  describe 'Deletion/Update logic test' do
    let!(:admin_user) { FactoryBot.create(:user, admin: true) }
    let!(:general_user) { FactoryBot.create(:user, admin: false) }

    context 'When trying to delete the last administrator' do
      it 'Deletion fails and an error message is added' do
        expect { admin_user.destroy }.not_to change(User, :count)
        expect(admin_user.errors[:base]).to include(I18n.t('users.errors.cannot_delete_last_admin'))
      end
    end

    context 'When trying to remove admin privileges from the last administrator' do
      it 'Update fails and an error message is added' do
        admin_user.admin = false
        admin_user.save
        expect(admin_user.reload.admin).to be true
        expect(admin_user.errors[:base]).to include(I18n.t('users.errors.cannot_demote_last_admin'))
      end
    end

    context 'When there are multiple administrators' do
      let!(:second_admin) { FactoryBot.create(:user, email: 'admin2@example.com', admin: true) }
      
      it 'One administrator can be deleted' do
        expect { admin_user.destroy }.to change(User, :count).by(-1)
      end
    end
  end
end