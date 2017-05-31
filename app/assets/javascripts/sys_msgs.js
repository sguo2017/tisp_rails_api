$(document).bind('turbolinks:load',function(){
  $('#sys_msg_accept_users_type').change(function(){
    $('#sys_msg_users_div').addClass('hidden');
    $('#sys_msg_cities_div').addClass('hidden');
    if($(this).val() == 'specify_cities'){
      $('#sys_msg_cities_div').removeClass('hidden');
    }else if($(this).val() == 'specify_users'){
      $('#sys_msg_users_div').removeClass('hidden');
    }
  });

  $("#new_sys_msg").submit(function(){
    $("#new_sys_msg  select").removeAttr("disabled");
  });
});

function clearValue(identify){
	$(identify).val('');
}

function selectAcceptUsers(user_id,obj,isCancle,user_input_field='#_sys_msgaccept_users'){
	textValues = $(user_input_field).val();
	if(textValues){
		var arrayValues = textValues.split(',');
	}else{
		var arrayValues = [];
	}
	if(!isCancle){
		arrayValues.push(user_id);
		$(user_input_field).val(arrayValues.join(','));
		
		$(obj).html('取消');
		$(obj).removeClass('btn-primary');
		$(obj).addClass('btn-danger');
		$(obj).removeAttr('onclick');
		$(obj).unbind();
		$(obj).bind('click',function(){selectAcceptUsers(user_id,obj,true);});
	}else{
		arrayValues = arrayValues.filter(x => x.toString() != user_id.toString());
		$(user_input_field).val(arrayValues.join(','));
		
		$(obj).html('选择');
		$(obj).removeClass('btn-danger');
		$(obj).addClass('btn-primary');
		$(obj).removeAttr('onclick');
		$(obj).unbind();
		$(obj).bind('click',function(){selectAcceptUsers(user_id,obj,false);});
	}
}
