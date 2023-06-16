class Hobby < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_many :hobby_tags,     dependent: :destroy
  has_many :tags,           through:   :hobby_tags
  has_many :hobby_comments, dependent: :destroy
  has_many :favorites,      dependent: :destroy
  has_many :to_does,        dependent: :destroy
  has_many :notifications,  dependent: :destroy

  has_many_attached :hobby_images

  with_options presence: true, on: :publicize do
    validates :title, length: { minimum: 1,maximum: 30 }
    validates :body, length: { minimum: 1,maximum: 500 }
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

  def save_tag(sent_tags)
    # タグが存在していれば、タグの名前を配列として全て取得
      current_tags = self.tags.pluck(:name) unless self.tags.nil?
      old_tags = current_tags - sent_tags
      new_tags = sent_tags - current_tags

      # 古いタグを消す
      old_tags.each do |old|
        self.tags.delete
        Tag.find_by(tag_name: old)
      end

      # 新しいタグを保存
      new_tags.each do |new|
        new_post_tag = Tag.find_or_create_by(tag_name: new)
        self.tags << new_post_tag
     end
  end
end
