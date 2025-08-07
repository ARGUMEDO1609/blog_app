class Reaction < ApplicationRecord
  belongs_to :reactable, polymorphic: true
  belongs_to :user

  validates :kind, presence: true
end
