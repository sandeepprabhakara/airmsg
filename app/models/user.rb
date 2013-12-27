class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :pins
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "initiator_id", dependent: :destroy
  has_many :responder_users, through: :relationships, source: :responder
  has_many :reverse_relationships, foreign_key: "responder_id", class_name: "Relationship", dependent: :destroy
  has_many :initiators, through: :reverse_relationships, source: :initiator

  validates :name, presence: true

  def feed
    #Micropost.where("user_id = ?", id)
    Micropost.from_users_responded_by(self)
  end

  def communicating?(other_user)
  	relationships.find_by(responder_id: other_user.id)
  end

  def communicate!(other_user)
  	relationships.create!(responder_id: other_user.id)
  end

	def uncommunicate!(other_user)
    relationships.find_by(responder_id: other_user.id).destroy!
  end

end
