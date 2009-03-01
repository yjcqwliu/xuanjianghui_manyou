class SnsMyActivity < ActiveRecord::Base
      belongs_to :sns_user
	  belongs_to :activity
end
