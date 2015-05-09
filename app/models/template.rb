class Template < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist
  has_many :rules
end
