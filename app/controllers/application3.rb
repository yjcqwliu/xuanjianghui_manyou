# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  require "pp"
  helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '7982602486defa6700eb432a7a0095d7'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  #platform = "manyou"
     
  #require  "platform/#{platform}.rb"
  require_login
  
      before_filter :set_current_user
   
  def set_current_user
  pp "--------------manyou_session:#{manyou_session.inspect}============="
	  if ! manyou_session.added	  
	     render :text =>"<my:redirect to='require_add' appid=\"#{manyou_session.app_Id}\"/> "
	  else
			  @callback_url = callback_url
			  
			  
			  if @current_user.nil?
					  @current_user = SnsUser.login(manyou_session.user)
					  if @current_user.session_key != manyou_session.session_key
					  @current_user.session_key = manyou_session.session_key
					   #@current_user.save
					  end
					  
			  end
			@current_user.prefix=manyou_session.prefix
			@current_user.friend_ids = manyou_session.friends.split(",")
		
			@current_user.friend_ids_will_change!
			@current_user.save
			  
      end  
  end
  #before_filter :set_current_user
  #def set_current_user
  #@current_user=SnsUser.login(1)
  #end
  
  def current_user
    @current_user
  end
  def ensure_admin
    #if not @current_user.admin
	 if @admin != "yjcqwliu" 
      #xn_redirect_to("homes/index",{:notice => "你没有权限"})
	  redirect_to(:controller => :home,:action => :index)
    end
  end
  
  def xn_redirect_to(to_url,feilds={})
    path = "#{to_url}?"
        feilds.each do |key,value|
			if value
			 path += "#{key}=#{URI.escape(value)}&"
			end
        end
    render :text => "<my:redirect url=\"#{path}\"/>"
	#render :text => "你没有权限操作"
  end

  def balance(usership)
	 #结算之前抢劫赚的钱

					 if usership.robof && usership.robof >0 
					     
							   if usership.robtime then
											cmp_time = Time.now - usership.robtime	
											cmp_money = conversion(cmp_time,usership.capacity,usership.robspeed)	
											@current_user.gold += cmp_money	
											@current_user.friend_ids_will_change!							
											@current_user.save
								end
								usership.robdock = 0
								usership.robuser.save
								usership.robof = 0
								usership.save
								cmp_money
					 end
	end
	
	def conversion(cmp_time,top=1000,speed=200) #传入时间差
	
	    time = fulltime(top , speed)*3600 #抢满的时间，此处为 小时*3600
		tt = cmp_time / time
		#pp("@@@@@@tt:#{tt}@@@@@time:#{time}@@@@cmp_time:#{cmp_time}@@")
		if tt > 1 
		   @conversion =  top
		else
		   @conversion = top * tt
		end 
		@conversion.to_i
	end

	def fulltime(top,speed)
	    t = top / (speed * 1.0)
	    #pp("----t:#{t}-----")
	    t
	end
	
	def rob_balance(usership,to_user=0)
	    if usership.robof && usership.robof >0 
			notice = Notice.new()
			notice.user_id = current_user.id
			notice.from_xid = current_user.xid
			notice.to_xid = usership.robof 
			money = balance(usership)
			notice.content = ["#{url_to_island(notice.from_xid)}船长驾驶他的#{usership.name}在#{url_to_island(notice.to_xid)}的岛上烧杀抢掠一番，抢劫了#{money}金币",
			"#{url_to_island(notice.from_xid)}船长一边唱着“我是个大盗贼，什么都不怕”一边开着他的#{usership.name}带着从#{url_to_island(notice.to_xid)}的岛上抢来的#{money}金币和一群美女悠闲的离开了"].rand
		
			
			notice.ltype = 1
			notice.save
		end
	    
	end
	
	def reseize_balance(usership)
	    notice = Notice.new()
		notice.user_id = current_user.id
		notice.from_xid = current_user.xid
		notice.to_xid = usership.user.xid
		money = balance(usership)
		notice.content = ["#{url_to_island(notice.from_xid)}船长成功的击退了#{url_to_island(notice.to_xid)}的进攻，夺回了#{money}金币","#{url_to_island(notice.to_xid)}被#{url_to_island(notice.from_xid)}船长一炮打回老家，抢劫行动宣告失败，留下了#{money}金币归#{url_to_island(notice.from_xid)}所有了"].rand
		notice.ltype = 1
		notice.save
		
	end
	
	def url_to_island(xid)
	    url = "<a href=\"/home/friend/#{xid}\"><my:name uid=\"#{xid}\" linked=\"true\"/></a>"
	end
	
	def invite_blance
	#邀请奖励
	    if @current_user.invite && @current_user.invite != 0
		    invite_array = @current_user.invite || []
			invite_user = SnsUser.find(:all,
			                        :conditions => [" xid in (?)",invite_array]
								   )
			invite_user.each do |iu|
			    iu.gold += 1000
				iu.pgold += 1
				iu.save
				        notice = Notice.new()
						notice.user_id = iu.id
						notice.from_xid = current_user.xid
						notice.to_xid = iu.xid
						notice.content = ["#{url_to_island(notice.from_xid)}接受了邀请，加入了海盗时代，#{url_to_island(notice.to_xid)}获得1000金币和1海盗币"].rand
						notice.ltype = 2
						notice.save
			end
					
		end 
        @current_user.invite = 0
		#@current_user.friend_ids_will_change!
		#@current_user.save
	end
	def login_award 
	    if !@current_user.award_updated_at or @current_user.award_updated_at < (Time.now - 3.hour)
		    @current_user.gold += 300
			@current_user.award_updated_at=Time.now
			notice = Notice.new()
			notice.user_id = current_user.id
			notice.from_xid = current_user.xid
			notice.to_xid = current_user.xid
			notice.content = ["#{url_to_island(notice.from_xid)}踏入了海盗时代，从自己的港口收取了300金币保护费"].rand
			notice.ltype = 10
			notice.save
		end
	end
	def init 
	   
	
	    ###############贸易相关数据初始化#################
		@current_user.business_update_at = Time.now.utc if @current_user.business_update_at.nil?
		#business_update_time = @current_user.business_update_at.strftime("%Y/%m/%d")
		#now = Time.now.strftime("%Y/%m/%d")
		#pp("-----------business_update_time:#{@current_user.business_update_at}-----now:#{Time.now}--------")
		#pp("-----------business_update_time:#{@current_user.business_update_at.to_i / 86400}-----now:#{Time.now.to_i / 86400}-----#{Time.now - @current_user.business_update_at}----")
	    @current_user.business_top = 20 if @current_user.business_top.nil?
		
	    @current_user.business_count = 0 if @current_user.business_count.nil? || Time.now.utc.to_i / 86400 > @current_user.business_update_at.to_i / 86400

		
		###############贸易相关数据初始化结束#################
		invite_blance #处理邀请数据
		login_award   #登陆奖励
	end
	def rescue_action_in_public(exception)
		case exception.class.name
		when
	'ActiveRecord::RecordNotFound','::ActionController::UnknownAction','::ActionController::RoutingError' 
			 RAILS_DEFAULT_LOGGER.error("404 displayed")
			 render(:file => "#{RAILS_ROOT}/public/404.html") 
		 else
			RAILS_DEFAULT_LOGGER.error("500 displayed")
			render(:file => "#{RAILS_ROOT}/public/500.html")
		end
	end

	def rescue_action_locally(exception)
    case exception.class.name
    when 'ActiveRecord::RecordNotFound','::ActionController::UnknownAction','::ActionController::RoutingError' 
        RAILS_DEFAULT_LOGGER.error("404 displayed")
        render(:file => "#{RAILS_ROOT}/public/404.html") 
     else
        RAILS_DEFAULT_LOGGER.error("500 displayed")
        render(:file => "#{RAILS_ROOT}/public/500.html")
    end
	
	
	end
	
	def callback_url
	    ENV['callback_url'] 
	end
end
