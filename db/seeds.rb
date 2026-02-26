# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create 25 sample tasks for testing pagination
# Remove the 50.times loop and use explicit creation
Task.create!(title: "first_task", content: "Description 1", deadline_on: "2022-02-18", priority: :medium, status: :not_started)
Task.create!(title: "second_task", content: "Description 2", deadline_on: "2022-02-17", priority: :high, status: :in_progress)
Task.create!(title: "third_task", content: "Description 3", deadline_on: "2022-02-16", priority: :low, status: :completed)
Task.create!(title: "fourth_task", content: "Description 4", deadline_on: "2022-02-20", priority: :medium, status: :not_started)
Task.create!(title: "fifth_task", content: "Description 5", deadline_on: "2022-02-21", priority: :high, status: :in_progress)
Task.create!(title: "sixth_task", content: "Description 6", deadline_on: "2022-02-22", priority: :low, status: :completed)
Task.create!(title: "seventh_task", content: "Description 7", deadline_on: "2022-02-23", priority: :medium, status: :not_started)
Task.create!(title: "eighth_task", content: "Description 8", deadline_on: "2022-02-24", priority: :high, status: :in_progress)
Task.create!(title: "ninth_task", content: "Description 9", deadline_on: "2022-02-25", priority: :low, status: :completed)
Task.create!(title: "tenth_task", content: "Description 10", deadline_on: "2022-02-26", priority: :medium, status: :not_started)

puts "Created 10 unique tasks successfully!"