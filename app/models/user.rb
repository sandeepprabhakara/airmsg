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

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "50x50>", :profile => "150x150>" }

  validates :name, presence: true

  searchable do
    text :name, :description, :location
  end

  def feed
    #Micropost.where("user_id = ?", id)
    Micropost.from_users_responded_by(self).order("created_at DESC")
  end

  # I added this. May need to delete
  def conversation(other_user)
    #Micropost.from_certain_user(self).order("created_at DESC")
    #Micropost.from_certain_user(self)
    Micropost.where("user_id = ? OR user_id = ?", other_user.id, id)
  end

  def conversation_list(first_user, second_user)
    #Micropost.from_certain_user(self).order("created_at DESC")
    #Micropost.from_certain_user(self)
    Micropost.where("user_id = ? OR user_id = ?", first_user.id, second_user.id)
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
