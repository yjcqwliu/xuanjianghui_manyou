class HomeController < ApplicationController
	before_filter :check_network, :except => [:network,:save_network]
	def index
        @act_location = params[:location] || @current_user.act_location
		@time_select = params[:time_select] || 93  #默认情况下显示最近7天内将要举行的活
		@keywords = params[:keywords] || nil
		@activity = find_location_in_activity({:act_location => @act_location, :time_select => @time_select, :keywords => @keywords})
		@page = params[:page] || 1
		@activity = @activity.paginate(:page => @page, :per_page => 20)
		#pp "-------current_user.activity#{current_user.activity.inspect}----"
	end
	
	def my
        @activity = @current_user.activity.joined
		@page = params[:page] || 1
		@activity = @activity.paginate(:page => @page, :per_page => 20)
		render :action => :my
	end
	
	def my_start
	    @activity = @current_user.activity.starting
		@page = params[:page] || 1
		@activity = @activity.paginate(:page => @page, :per_page => 20)
		render :action => :my
	end
	
	def my_timeout
	    @activity = @current_user.activity.timeout
		@page = params[:page] || 1
		@activity = @activity.paginate(:page => @page, :per_page => 20)
		render :action => :my
	end
	
	def friend
        @act_location = @current_user.act_location
        @activity = @current_user.friend_activity
		@page = params[:page] || 1
		@activity = @activity.paginate(:page => @page, :per_page => 20)
		render :action => :index
	end
  def activity_user
		@user = SnsUser.activity_user()
		#render :action => :index
	end
	
	def allcity
        @act_location = @current_user.act_location
		@activity = find_location_in_activity({:time_select => @time_select, :keywords => @keywords})
		@page = params[:page] || 1
		@activity = @activity.paginate(:page => @page, :per_page => 20)
		render :action => :index
	end
	def network
	    
	end
	def save_network
	    begin
		    @current_user.act_location = params[:city]
			@current_user.save
			xn_redirect_to("home/index")
		rescue
		    xn_redirect_to("home/network")
		end
	end
	private
	def check_network
		if @current_user.act_location.blank?
			xn_redirect_to("home/network")
		end
	end
	def find_location_in_activity(tmp_params)
	      #tmp_arr = [" calendar_id in (1684,1685,1688,1691,1690,1695,1724,1692, 1693,1696,1712,1736,1728,1687,1732,1689,1716,1720,1686,1694,94318) and start_time > ? ", Time.now]
		tmp_arr = [" 1=1 "]
    if ! tmp_params[:act_location].blank?
		       tmp_arr[0] += " and act_location = ? "
               tmp_arr << tmp_params[:act_location]
		   end
		   if ! tmp_params[:keywords].blank?
		       tmp_arr[0] += " and act_subject like ? "
               tmp_arr << "%#{tmp_params[:keywords]}%"
		   end
		   if ! tmp_params[:time_select].blank?
		       tmp_arr[0] += " and start_time < ? "
               tmp_arr << Time.now + tmp_params[:time_select].to_i.day
		   end	
		   #pp "-----------------tmp_arr:#{tmp_arr.inspect}--------------"
		   @loc_activity = Activity.find(:all,:conditions => tmp_arr, :order => " start_time ASC")
	end

end
