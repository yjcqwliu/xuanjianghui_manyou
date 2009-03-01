class EventController < ApplicationController
    def show
	    if id = params[:id] 
		    @activity = Activity.find(id)
			@my_activity = @current_user.my_activity_find_by_id(id)
			@join_user = []
		    i = 0
		    @activity.join_user.each do |u| 
				i += 1
				if i > 6 
				   break
				end
				@join_user << SnsUser.find(u.sns_user_id).xid
		    end
			@message = @activity.sns_commit
		 end
	end
	def userlist
	    if id = params[:id]
			@activity = Activity.find(id)
		    @userlist = @activity.sns_user
		end
		@page = params[:page] || 1
		@userlist = @userlist.paginate(:page => @page, :per_page => 20)
	end
	def message
	    if id = params[:id]
			@activity = Activity.find(id)
		    @message = @activity.sns_commit
		end
		@page = params[:page] || 1
		@message = @message.paginate(:page => @page, :per_page => 10)
	end
	def save_message
	    commit = params[:commit]
		if !commit[:content].blank? and commit[:content].length <1000  #留言字数限制
		    commit[:sns_user_xid] = @current_user.xid
			SnsCommit.create(commit)
		end
		xn_redirect_to("event/show/#{commit[:activity_id]}")
	end
	def share
		if id = params[:id] 
		      my_activity = @current_user.my_activity_find_by_id(id)
		      if my_activity
			       my_activity.share = true
				   my_activity.save
			  else   
			       @current_user.sns_my_activity.create(:activity_id =>id,:share => true)
			  end
		end
		xn_redirect_to("event/show/#{id}")
	end
	def join
        if id = params[:id] 
		      my_activity = @current_user.my_activity_find_by_id(id)
			  awoketime = params[:awoketime].to_i
			  mailbox = params[:mailbox]
		      if my_activity
			       my_activity.join = true
				   my_activity.save
			  else   
			       @current_user.sns_my_activity.create(:activity_id =>id,:join => true)
			  end
			  @current_user.mailbox = params[:mailbox] if params[:mailbox]
			  @current_user.save
			  @activity = Activity.find(id)
			  mail = MailReminding.find(:first,:conditions =>["activity_id = ? and user_id =?",id, @current_user.id])  #如果邮件提醒中没有该信息则添加
			  if mail
			  		mail.activity_id = id
					mail.title = @activity.act_subject
					mail.user_id = @current_user.id
					mail.link = "http://www.iease.com.cn/events/#{id}"
					mail.start_time =  @activity.start_time
					mail.end_time =  @activity.end_time
					mail.remind_time =  @activity.start_time - awoketime.day
					mail.done = 0
					mail.mailbox = mailbox
					mail.act_subject = act_subject
			  else
			   		MailReminding.create(
					:activity_id => id,
					:title => @activity.act_subject, 
					:user_id => @current_user.id,
					:link => "http://www.iease.com.cn/events/#{id}",
					:start_time =>  @activity.start_time,
					:end_time =>  @activity.end_time,
					:remind_time =>  @activity.start_time - awoketime.day,
					:done => 0,
					:mailbox => mailbox,
					:act_subject => @activity.act_subject
					)
			  end
		end
		xn_redirect_to("event/show/#{id}")
	end
	def interest
        if id = params[:id] 
		      my_activity = @current_user.my_activity_find_by_id(id)
		      if my_activity
			       my_activity.interest = true
				   my_activity.save
			  else   
			       @current_user.sns_my_activity.create(:activity_id =>id,:interest => true)
			  end
		end
		xn_redirect_to("event/show/#{id}")
	end
	def unjoin
        if id = params[:id] 
		      my_activity = @current_user.my_activity_find_by_id(id)
		      if my_activity
			       my_activity.join = false
				   my_activity.save
			  end
			  m = MailReminding.find(:first,:conditions =>["activity_id = ? and user_id =?",id, @current_user.id])
			  m.destroy
		end
		xn_redirect_to("event/show/#{id}")
	end
	def uninterest
	    if id = params[:id] 
		      my_activity = @current_user.my_activity_find_by_id(id)
		      if my_activity
			       my_activity.interest = false
				   my_activity.save
			  end
		end
		xn_redirect_to("event/show/#{id}")
	end
end
