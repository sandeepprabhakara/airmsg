class Relationship < ActiveRecord::Base
	belongs_to :initiator, class_name: "User"
	belongs_to :responder, class_name: "User"
	has_many :pins
	#has_many :microposts
	belongs_to :users
	validates :initiator_id, presence: true
	validates :responder_id, presence: true

	attr_accessible :initiator_id, :responder_id
end
