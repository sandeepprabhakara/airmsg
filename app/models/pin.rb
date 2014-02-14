class Pin < ActiveRecord::Base
	belongs_to :user;
	belongs_to :relationship;
	belongs_to :initiator, class_name: "User"
	belongs_to :responder, class_name: "User"
	has_many :eavesdrops;

	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "50x50>", :profile => "150x150>"}, :default_url => 'default_gravatar.jpeg'

	#validates :image, presence: true
	validates :description, presence: true
	attr_accessible :description, :user_id, :initiator_id, :responder_id
	searchable do
		text :description
		# :message1, :message2, :message3, :message4, :message5, :message6
		#, :name
	end

end
