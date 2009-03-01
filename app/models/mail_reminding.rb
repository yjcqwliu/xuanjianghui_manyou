class MailReminding < ActiveRecord::Base
	belongs_to :sns_user
end
