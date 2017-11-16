class Message < ActiveRecord::Base

  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'

  validates :title, presence: true
  validates :content, presence: true
  validates :sender_id, presence: true
  validates :recipient_id, presence: true
  
  before_destroy :check_before_deletion 

  scope :unread, -> {where(read: true)}


  def mark_as_read(user)
    return if read || !recipient?(user.id)
    update_column(:read, true)
  end

  def sender?(user_id)
    sender_id == user_id
  end

  def recipient?(user_id)
    recipient_id == user_id
  end

  private
  def check_before_deletion
    puts '1'
    return true unless read
    puts '2'
    errors[:base] << "cannot delete message that has already been read"
    puts '3'
    return false
  end
end
