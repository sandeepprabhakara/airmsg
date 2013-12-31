class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :content, length: { maximum: 1000 }
	#validates :user_id, presence: true


	def self.from_users_responded_by(user)
    #responder_user_ids = user.responder_user_ids
    #where("user_id IN (?) OR user_id = ?", responder_user_ids, user)

    responder_user_ids = "SELECT responder_id FROM relationships WHERE initiator_id = :user_id"
    where("user_id IN (#{responder_user_ids}) OR user_id = :user_id", user_id: user.id)
  end

  #this function is not needed. should be deleted
  def self.from_certain_user(user)
    responder_user_ids = user.id
    where("user_id IN (?) OR user_id = ?", responder_user_ids, user)

    #responder_user_ids = user.id
  end

  
end
