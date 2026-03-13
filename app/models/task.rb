class Task < ApplicationRecord
  belongs_to :user
  
  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  # Enums for priority and status
  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  # --- STEP 3: Sorting Scopes ---
  # Sort by expiration date ascending, THEN by creation date descending
  scope :sort_deadline_on, -> { order(deadline_on: :asc, created_at: :desc) }
  
  # Sort by priority descending (High first), THEN by creation date descending
  scope :sort_priority, -> { order(priority: :desc, created_at: :desc) }
  
  # Default sort from Step 2: Newest created first
  scope :sort_created_at, -> { order(created_at: :desc) }

  # --- STEP 3: Searching Scopes ---
  # Fuzzy search for title 
  scope :search_title, ->(title) { where('title LIKE ?', "%#{title}%") }
  # Exact match search for status
  scope :search_status, ->(status) { where(status: status) }
end