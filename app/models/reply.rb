require 'word_check'
include WordCheck::Worker

class Reply < ApplicationRecord

  include Sensitive

  acts_as_paranoid

  #Association
  belongs_to :user, counter_cache: true
  belongs_to :post
  has_one :blogger, through: :post, source: 'user'
  has_many :messages, as: :target, dependent: :destroy
  has_one :postgresql_search, as: :searchable

  #Validate
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true, allow_blank: false

  #Scope
  default_scope -> { order('created_at desc') }

  #Callback
  after_create :message_to_at_users, :update_last_reply_user

  def update_last_reply_user
    post.last_reply_user_id = user_id
    post.save
  end

  def published_time
    created_at.strftime('%Y-%m-%d %H:%M')
  end

  def message_to_at_user(at_user)
    # return if self.user.id == at_user.id
    message = self.messages.build(
        is_read: false,
        user_id: at_user.id,
        from_user_id: self.user.id,
        body: "#{self.user.uid} @了你: #{self.content}"
    )
    message.save
  end

  def message_to_blogger
    return if user.id == blogger.id
    message = messages.build(
        is_read: false,
        user_id: blogger.id,
        from_user_id: user.id,
        body: "#{user.uid} 回复了你: #{content}"
    )
    message.save
  end

  private

  def message_to_at_users
    at_users = []
    self.content.gsub(/@(\w{3,20})/) {
      uid = "#{$1.strip.sub('@', '')}"
      user = class_for(:user).find_by(uid: uid)

      if user.present? && !at_users.include?(user)
        at_users << user
      end
    }

    at_users.each { |at_user| self.message_to_at_user(at_user) }
    self.message_to_blogger unless at_users.include?(self.blogger)
  end

end
