class AchieveTrophy < ApplicationRecord
  has_one :trophy
  belongs_to :project
end
