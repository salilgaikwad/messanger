class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id'

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true

  scope :recipients, -> (user_id) {where.not(id: user_id)}

  def full_name
    first_name + ' ' + last_name
  end

end
