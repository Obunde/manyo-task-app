class Task < ApplicationRecord

  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  belongs_to :user
  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings

  # Default sort (newest first)
  scope :recent, -> { order(created_at: :desc) }

  # Sort by deadline ascending
  scope :sort_by_deadline, -> { reorder(deadline_on: :asc) }

  # Sort by priority descending
  scope :sort_by_priority, -> { reorder(priority: :desc) }

  # Search scopes
  scope :search_title, ->(title) { where("title LIKE ?", "%#{title}%") }
  scope :search_status, ->(status) { where(status: status) }


  def self.apply_sorting(params)
    if params[:sort_deadline_on]
      sort_by_deadline
    elsif params[:sort_priority]
      sort_by_priority
    else
      recent
    end
  end

  def self.apply_filtering(params)
    results = all # Start with a clean scope
    
    if params[:search].present?
      results = results.search_title(params[:search][:title]) if params[:search][:title].present?
      results = results.search_status(params[:search][:status]) if params[:search][:status].present?
    end
    
    results
  end
end

