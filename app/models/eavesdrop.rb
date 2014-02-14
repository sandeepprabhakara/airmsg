class Eavesdrop < ActiveRecord::Base

	belongs_to :user;
	belongs_to :initiator, class_name: "User"
	belongs_to :responder, class_name: "User"
	belongs_to :pin;

	attr_accessible :user_id, :initiator_id, :responder_id
end
