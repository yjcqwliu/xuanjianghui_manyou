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
  #platform = "xiaonei"
     
  #require  "platform/#{platform}.rb"
  require_login
      before_filter :set_current_user
   
  def set_current_user
	  if ! manyou_session.added	  
	     render :text =>"<my:redirect to='require_add' appid=\"#{manyou_session.app_Id}\"/> "
	  else  
	
			if @current_user.nil?
			  @current_user = SnsUser.find_by_xid(manyou_session.user)
			  if @current_user.session_key != manyou_session.session_key
			  @current_user.session_key = manyou_session.session_key
			   #@current_user.save
			  end
			end
			@current_user.prefix=manyou_session.prefix
			@current_user.friend_ids = manyou_session.friends.split(",") if manyou_session.friends
			
			@current_user.friend_ids_will_change!
			@current_user.save
		end
  end
  
  def current_user
    @current_user
  end
  
  def xn_redirect_to(to_url,feilds={})
    path = "#{to_url}?"
        feilds.each do |key,value|
	     path += "#{key}=#{URI.escape(value)}&"
        end
    render :text => "<my:redirect url=\"#{path}\"/>"
  end

end
