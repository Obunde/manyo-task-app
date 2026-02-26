require 'rails_helper'

RSpec.describe "Admin User Management", type: :system do
  let!(:admin) { create(:user, :admin) }

  before do
    # Login as admin
    visit new_session_path
    fill_in "Email address", with: admin.email
    fill_in "Password", with: "password"
    click_button "Login"
  end

  describe "Prevent deleting last admin" do
    it "does not allow deletion if only one admin exists" do
      visit admin_users_path
      click_link I18n.t("common.delete")

      expect(page).to have_content(I18n.t("users.errors.cannot_delete_last_admin"))
    end
  end

  describe "Prevent removing last admin privilege" do
    it "does not allow removing admin role if only one admin exists" do
      visit edit_admin_user_path(admin)

      uncheck User.human_attribute_name(:admin)
      click_button I18n.t("admin.users.form.update")

      expect(page).to have_content(I18n.t("users.errors.cannot_demote_last_admin"))
    end
  end

  describe "Allow deletion if multiple admins exist" do
    let!(:second_admin) { create(:user, :admin) }

    it "allows deleting one admin if another exists" do
      visit admin_users_path

      # Delete second admin (not self)
      within("tr", text: second_admin.email) do
        click_link I18n.t("common.delete")
      end

      expect(page).to have_content(I18n.t("admin.users.notice.destroyed"))
      expect(page).not_to have_content(second_admin.email)
    end
  end
end