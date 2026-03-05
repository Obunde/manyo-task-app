class Label < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tasks, through: :labellings
  has_many :labellings, dependent: :destroy
end
