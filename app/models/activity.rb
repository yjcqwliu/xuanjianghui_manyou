class Activity < ActiveRecord::Base
    has_one :act_text
	has_many :sns_my_activity
	has_many :sns_user, :through => :sns_my_activity
	has_many :sns_commit, :order => "created_at DESC "
	def interest_user
	    tmp_user = []
		sns_my_activity.each do |u|
		    if u.interest == true
			     tmp_user << u
			end
		end
		tmp_user
	end
	def join_user
	    tmp_user = []
		sns_my_activity.each do |u|
		    if u.join == true
			     tmp_user << u
			end
		end
		tmp_user
	end
	def share_user
	    tmp_user = []
		sns_my_activity.each do |u|
		    if u.share == true
			     tmp_user << u
			end
		end
		tmp_user
	end
	
end
