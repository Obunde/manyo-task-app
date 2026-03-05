class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy # Requirement: Delete tasks when user is deleted

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }

  before_validation { email.downcase! } # Case-insensitive requirement
  before_destroy :ensure_admin_exists
  before_update :ensure_admin_exists_if_changing

  private
  def ensure_admin_exists
    if admin? && User.where(admin: true).count == 1
      errors.add(:base, I18n.t("users.errors.cannot_delete_last_admin"))
      throw(:abort)
    end
  end

  def ensure_admin_exists_if_changing
    if admin_changed?(from: true, to: false) && User.where(admin: true).count == 1
      errors.add(:base, I18n.t("users.errors.cannot_demote_last_admin"))
      throw(:abort)
    end
  end
end