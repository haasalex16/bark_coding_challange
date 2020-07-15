class Dog < ApplicationRecord
  include Likeable

  has_many_attached :images
  belongs_to :user

  def like_count
    likes.where(liked: true).size
  end
end
