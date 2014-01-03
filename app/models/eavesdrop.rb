class Eavesdrop < ActiveRecord::Base

	belongs_to :user;
	belongs_to :initiator, class_name: "User"
	belongs_to :responder, class_name: "User"
	belongs_to :pin;

end
