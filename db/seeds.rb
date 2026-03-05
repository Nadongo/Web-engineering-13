# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
50.times do |n|
  Task.create!(
    title: "Test Task #{n + 1}",
    content: "This is the dummy content for task number #{n + 1}.",
    # This makes the deadline a different day for each task
    deadline_on: Date.today + n.days,
    # This cycles through 0 (low), 1 (medium), and 2 (high)
    priority: n % 3,
    # This cycles through 0 (not_started), 1 (in_progress), and 2 (completed)
    status: n % 3
  )
end