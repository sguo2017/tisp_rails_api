$(document).on('turbolinks:load',function(){
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
