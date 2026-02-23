# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create 25 sample tasks for testing pagination
50.times do |i|
  Task.create(
    title: "Task #{i + 1}",
    content: "This is the content for task #{i + 1}. Lorem ipsum dolor sit amet.",
    deadline_on: Date.current + i.days,
    priority: Task.priorities.keys[i % Task.priorities.size],
    status: Task.statuses.keys[i % Task.statuses.size]
  )
end

puts "Created 50 sample tasks!"
