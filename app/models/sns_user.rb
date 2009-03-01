class SnsUser < ActiveRecord::Base
    serialize :friend_ids
	has_many :sns_my_activity
	has_many :mail_reminding
	has_many :activity, :through => :sns_my_activity, :order => 'id desc '  do
	    def joined
		     find(:all,:conditions => ["  start_time > ? ", Time.now],:order => "start_time ASC")
		end
		def starting
		     find(:all,:conditions => ["  start_time > ? and end_time < ?  ", Time.now, Time.now],:order => "start_time ASC")
		end
		def timeout
		     find(:all,:conditions => ["  end_time < ? ", Time.now],:order => "start_time ASC")
		end
	end
	
	attr_accessor :prefix
	
	def self.find_by_xid(t_xid)
	    t_u = SnsUser.find(:first,:conditions => [" xid = ?",t_xid.to_s])
		if t_u
		   t_u
		else
		   t_u = SnsUser.create({:xid => t_xid})
		end
	end
    def xn_session #调用校内API
		@xn_session ||= Xiaonei::Session.new("xn_sig_session_key" => session_key, "xn_sig_user" => xid)
	end
	def my_activity_find_by_id(act_id)  #获取该好友与传入的id对应activity表中记录之间的关系
	    tmp_my_activity = nil
	    sns_my_activity.each do |m|
		    if m.activity_id.to_i == act_id.to_i
			    tmp_my_activity = m
			    break
			end
		end
		tmp_my_activity
	end
	def friend_id_in_sns_user
	    if @friend_id_in_sns_user
			@friend_id_in_sns_user
		else
			@friend_id_in_sns_user = []
			SnsUser.find(:all,:conditions => [" xid in (?) ",friend_ids],:select => "id").each do |s|
			@friend_id_in_sns_user << s.id
			end 
			@friend_id_in_sns_user
		end
	end
	def friend_activity  
		tmp_activity = []
		my_friend_ids = friend_id_in_sns_user
		friend_join_activity = SnsMyActivity.find(:all,:conditions => [" sns_user_id in (?)",my_friend_ids])
		pp("-----friend_join_activity:#{friend_join_activity.inspect}--------")
		friend_join_activity.each do |a|
			if a.join
				tmp_act = Activity.find(:first,:conditions => [" id = ?",a.activity_id])
				tmp_activity << tmp_act if tmp_act and !tmp_activity.include?(tmp_act)
			end
		end
		tmp_activity
	end
  def self.activity_user
    #uactivity = SnsMyActivity.find(:all)
    count_arr = SnsMyActivity.count(:group => "sns_user_id",:order => "count_all DESC",:limit => 20)
    tmp_activity = []
    pp "======================="+count_arr.inspect+"======================="
    count_arr.each do |a|
			if  a[1] > 0
				tmp_user = SnsUser.find(:first,:conditions => [" id = ?",a[0]])
        if tmp_user and !tmp_activity.include?(tmp_user)
          tmp_user["count_all"] = a[1]
          tmp_activity << tmp_user
        end
			end
		end
		tmp_activity
  end
end 