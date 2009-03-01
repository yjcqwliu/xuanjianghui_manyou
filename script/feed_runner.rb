start_time = Time.now
puts "start:#{start_time}"
SnsMyActivity.find(:all, :conditions => [" share = true  " ],:order => " updated_at desc ", :limit => 5000).each do |notice|
  begin
   current_time = Time.now
   if notice.activity
	   title = notice.activity.act_subject
	   if notice.activity.act_text
			content = notice.activity.act_text.act_description[0,50].gsub("\n","")
	   
			#res_note = notice.sns_user.xn_session.invoke_method("xiaonei.notifications.send", 
			#												:to_ids => notice.to_xid, 
			#												:notification => content)
			puts "--------title:#{title.chars}-----content:#{content.chars}---------"
				res_feed = notice.sns_user.xn_session.invoke_method("xiaonei.feed.publishTemplatizedAction", 
																:title_data => { 
																:title => title
														        }.to_json, 
																:body_data => { 
																:content => content
														        }.to_json, 
																:template_id => 1)
			puts "#{current_time}: process user #{notice.sns_user.id}:  #{res_feed.inspect} "
			
			notice.share = false
			notice.save
		end 
	end
  rescue Exception => exp
    puts "exp: #{exp.inspect}"
  end
end


