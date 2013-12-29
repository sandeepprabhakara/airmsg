class Pin < ActiveRecord::Base
	belongs_to :user;
	belongs_to :relationship;
	belongs_to :initiator, class_name: "User"
	belongs_to :responder, class_name: "User"

	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }

	#validates :image, presence: true
	validates :description, presence: true

	searchable do
		text :description, :message1, :message2, :message3, :message4, :message5, :message6
		#, :name
	end
end
