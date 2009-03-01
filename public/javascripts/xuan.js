function seeOtherCity(){  
    var city_dialog;	
	function go_url_callback(){
       var city = document.getElementById('select_city').getValue();
       document.setLocation('/xuanjianghui?location=' + encodeURIComponent(city));
    }
	if (!seeOtherCity.city_dialog) {
	 city_dialog = seeOtherCity.city_dialog =
	     new Dialog(Dialog.DIALOG_PANEL, {
	     body: select_city_jstring,
	     header: '选择你想查看的城市'
	   }
	 );
	
	 var button1 = new Button('确定', go_url_callback);
	 city_dialog.addFooter(button1);
	}
	else {
		city_dialog = seeOtherCity.city_dialog;
	}
    
    city_dialog.show();
}
function set_join(event_id){ 
    var join_dialog;	
	function go_url_callback(){
		mailboxvalue = document.getElementById('mailbox').getValue();
		if(/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.exec(mailboxvalue))
		{
			awoketimevalue = document.getElementById('awoketime').getValue();		
			join_event_id = document.getElementById('join_event_id').getValue();
			document.setLocation('/xuanjianghui/event/join/' + encodeURIComponent(join_event_id) + '?mailbox=' + encodeURIComponent(mailboxvalue) + '&awoketime=' + encodeURIComponent(awoketimevalue));
		}
		else
		{
			document.getElementById('email_error').setTextValue("邮箱格式错误");		
	    }
    }
	function join_cancel(){
		join_dialog.hide();
	}
	if (!set_join.join_dialog) {
	 join_dialog = set_join.join_dialog =
	     new Dialog(Dialog.DIALOG_PANEL, {
	     body: set_join_jstring,
	     header: '输入提醒信息'
	   }
	 );
	
	 var button1 = new Button('确定', go_url_callback);
	 join_dialog.addFooter(button1);
	 var button2 = new Button('取消', join_cancel);
	 join_dialog.addFooter(button2);
	}
	else {
		join_dialog = set_join.join_dialog;
	}
    
    join_dialog.show();
	document.getElementById("join_event_id").setValue(event_id);
}
function chgunivright(){
    var time_select= document.getElementById('select_days').getValue();
    document.setLocation('/xuanjianghui?location=' + encodeURIComponent('<%= @act_location %>') + '&keywords=' + encodeURIComponent('<%= @keywords %>') + '&time_select=' + time_select);
}
function reply_message(xid,commit_id){
	document.getElementById('commit[reply_xid]').setValue(xid);
}