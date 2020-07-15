class Dog < ApplicationRecord
  include Likeable

  has_many_attached :images
  belongs_to :user
end
