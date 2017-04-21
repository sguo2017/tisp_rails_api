//整个网站使用到的一些全局的js,会被引入application.js当中，全站有效

//Rails中JQuery的ready事件只会在网站第一次被打开时加触发，在链接跳转时不会触发
//所以这里使用了'turbolinks:load'事件
$(document).on('turbolinks:load', showDatePicker); 
function showDatePicker(){
	$.fn.datepicker.dates['cn'] = {
		days: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
		daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
		daysMin: ["日", "一", "二", "三", "四", "五", "六"],
		months: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
		monthsShort: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
		today: "今天",
		clear: "清除",
		format: "yyyy-mm-dd",
		titleFormat: "yyyy年 MM", /* Leverages same syntax as 'format' */
		weekStart: 0
	};
	$('.date-picker').datepicker({
		format: 'yyyy-mm-dd',
		endDate: '0d',
		language: 'cn'
    });
}
function updateUserWithAvatar(){
	var input_file = document.getElementById('user_avatar_file');
	if(input_file.files.length!=1){
		$('#edit_user').submit();
		return;
	}else{
		fetch("/api/session/users/avatar/server_url")
		.then(response => response.text())
		.then(text=>JSON.parse(text)['server_url'])
		.then(server_url =>uploadAndSubmit(server_url))
		.catch(e => console.log("error:", e));
		var uploadAndSubmit=function(avatar_server_url){
			let formData = new FormData();
			let url = avatar_server_url
			formData.append("image", input_file.files[0]);
			fetch(url, {
			   method: 'POST',
			   mode: "cors",
			   body: formData,
			})
		   .then((response) => response.text())
		   .then((responseData) => {
			  console.log('responseData', responseData);
			  img_url=JSON.parse(responseData)['image'];
			  $('#user_avatar').val(img_url);
			  $('#user_avatar_file').removeAttr('name');
			  $('#edit_user').submit();
		   })
		   .catch((error) => { console.error('error', error) });
		};
	}
}

