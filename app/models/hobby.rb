class Hobby < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :tag,  optional: true
  has_many :hobby_comments, dependent: :destroy
  has_many :favorites,      dependent: :destroy
  has_many :to_does,        dependent: :destroy
  has_many :notifications,  dependent: :destroy

  has_many_attached :hobby_images

  validates :title, presence: true, length: { minimum: 1,maximum: 30 }, on: :publicize
  validates :body, presence: true, length: { minimum: 1,maximum: 500 }, on: :publicize

  def get_hobby_image(width, height)
    hobby_image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def checked_by?(user)
    to_does.exists?(user_id: user.id)
  end

  def self.looks(word)
    Hobby.where("title LIKE? OR body LIKE?", "%#{word}%","%#{word}%")
  end

  def self.random
    order('RANDOM()').first
  end
end
