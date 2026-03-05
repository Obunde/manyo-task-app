# Use find_or_create_by to avoid "email has already been taken"
admin_user = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name = "Admin User"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = true
end

general_user = User.find_or_create_by!(email: "general@example.com") do |user|
  user.name = "General User"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = false
end

# Clear existing tasks associated with these users to avoid duplicates
admin_user.tasks.destroy_all
general_user.tasks.destroy_all

# Create 50 tasks for Admin
50.times do |i|
  Task.create!(
    title: "Admin Task #{i + 1}",
    content: "Content for admin task #{i + 1}",
    deadline_on: Date.today + i.days,
    priority: :medium,
    status: :not_started,
    user: admin_user
  )
end

# Create 50 tasks for General User
50.times do |i|
  Task.create!(
    title: "General Task #{i + 1}",
    content: "Content for general task #{i + 1}",
    deadline_on: Date.today + i.days,
    priority: :low,
    status: :in_progress,
    user: general_user
  )
end

puts "Seed successful!"