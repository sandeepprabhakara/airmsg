class Relationship < ActiveRecord::Base
	belongs_to :initiator, class_name: "User"
	belongs_to :responder, class_name: "User"
	has_many :pins
	has_many :users
	validates :initiator_id, presence: true
	validates :responder_id, presence: true
end
