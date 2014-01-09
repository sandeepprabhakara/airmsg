class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,
         :invitation_limit => 1

  has_many :pins
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "initiator_id", dependent: :destroy
  has_many :responder_users, through: :relationships, source: :responder
  has_many :reverse_relationships, foreign_key: "responder_id", class_name: "Relationship", dependent: :destroy
  has_many :initiators, through: :reverse_relationships, source: :initiator
  has_many :eavesdrops

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "50x50>", :profile => "150x150>" }, :default_url => 'default_gravatar_:style.jpg'

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
    #Micropost.where("user_id = ? OR user_id = ?", other_user.id, id)
    current_user = User.find_by_id(id)
    Micropost.where("(initiator = (?) and responder = (?)) or (initiator = (?) and responder = (?))", current_user, other_user, other_user, current_user)
  end

  def conversation_list(initiator, responder)
    #Micropost.from_certain_user(self).order("created_at DESC")
    #Micropost.from_certain_user(self)
    #Micropost.where("user_id = ? OR user_id = ?", first_user.id, second_user.id)
    Micropost.where("initiator = ? AND responder = ?", initiator, responder)
  end

  def communicating?(current_user, other_user)
  	#relationships.find_by(responder_id: other_user.id)
    #Relationship.where("(initiator_id = ? AND responder_id = ?) or (initiator_id = ? AND responder_id = ?)", current_user.id, other_user.id, other_user.id, current_user.id)
    relationships.where("(initiator_id = ? AND responder_id = ?) or (initiator_id = ? AND responder_id = ?)", current_user.id, other_user.id, other_user.id, current_user.id)
    #relationships.where("(initiator_id = ? AND responder_id = ?)", current_user.id, other_user.id)
  end

  def communicate!(other_user)
  	relationships.create!(responder_id: other_user.id)
  end

	def uncommunicate!(other_user)
    relationships.find_by(responder_id: other_user.id).destroy!
  end

  def eavesdropping?(current_user, first_user, second_user)
    eavesdrops.find_by(user_id: current_user.id, initiator_id: first_user.id, responder_id: second_user.id)
  end

  def eavesdrop!(current_user, first_user, second_user)
    eavesdrops.create!(user_id: current_user.id, initiator_id: first_user.id, responder_id: second_user.id)
  end

  def uneavesdrop!(current_user, first_user, second_user)
    eavesdrops.find_by(user_id: current_user.id, initiator_id: first_user.id, responder_id: second_user.id).destroy!
  end

  def eaveslist(eavesdrop)
    #Micropost.where("user_id = ?", id)
    Pin.where("initiator_id = (?) AND responder_id = (?)", eavesdrop.initiator_id, eavesdrop.responder_id)
    #eavesdrop.Pin
    #Micropost.from_users_responded_by(self).order("created_at DESC")
  end

  def eaveslist_recommend()
    #Micropost.where("user_id = ?", id)
    Pin.where("recommend = (?)", 1)
    #eavesdrop.Pin
    #Micropost.from_users_responded_by(self).order("created_at DESC")
  end


protected
  #def confirmation_required?
    #false
  #end

end
