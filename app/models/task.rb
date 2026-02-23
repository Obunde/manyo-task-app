class Task < ApplicationRecord

  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  # Default sort (newest first)
  scope :recent, -> { order(created_at: :desc) }

  # Sort by deadline ascending
  scope :sort_by_deadline, -> { reorder(deadline_on: :asc) }

  # Sort by priority descending
  scope :sort_by_priority, -> { reorder(priority: :desc) }

  # Search scopes
  scope :search_title, ->(title) { where("title LIKE ?", "%#{title}%") }
  scope :search_status, ->(status) { where(status: status) }
end
