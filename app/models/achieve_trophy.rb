class AchieveTrophy < ApplicationRecord
  belongs_to :trophy
  belongs_to :project
end
