//整个网站使用到的一些全局的js,会被引入application.js当中，全站有效
//Rails中JQuery的ready事件只会在网站第一次被打开时加触发，在链接跳转时不会触发
//所以这里使用了'turbolinks:load'事件
var lazyInfo={}; //全局变量
$(document).bind('turbolinks:before-visit',function(){
  lazyInfo.left_at = new Date().format('yyyy-MM-dd hh:mm:ss');
  collectLazyInfos();
});
$(window).bind('beforeunload',function(){
  lazyInfo.left_at = new Date().format('yyyy-MM-dd hh:mm:ss');
  collectLazyInfos();
  return;
});
$(document).bind('turbolinks:load',function() {
  lazyInfo = {};
  showDatePicker();
  collectSimpleInfos();
  askForGeoInfos();
  $(".rucaptcha-refresh").click(function() {
    var src = $(".rucaptcha-image").attr('src');
    $(".rucaptcha-image").attr('src', src.split("?")[0] + "?timestamp=" + (new Date().getTime()));
    return false;
  });

});
Date.prototype.format = function(fmt) {
  var o = {
    "M+": this.getMonth() + 1,//月份
    "d+": this.getDate(),//日
    "h+": this.getHours(),//小时
    "m+": this.getMinutes(),//分
    "s+": this.getSeconds(),//秒
    "q+": Math.floor((this.getMonth() + 3) / 3),//季度
    "S": this.getMilliseconds() //毫秒
  };
  if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
  for (var k in o) if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
  return fmt;
}
function showDatePicker() {
  $.fn.datepicker.dates['cn'] = {
    days: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
    daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
    daysMin: ["日", "一", "二", "三", "四", "五", "六"],
    months: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
    monthsShort: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
    today: "今天",
    clear: "清除",
    format: "yyyy-mm-dd",
    titleFormat: "yyyy年 MM",
    weekStart: 0
  };
  $('.date-picker').datepicker({
    format: 'yyyy-mm-dd',
    endDate: '0d',
    language: 'cn'
  });
}
function submitFormWithImage(form, fileFieldId, hiddenFieldId) {
  var input_file = document.getElementById(fileFieldId);
  if ($("#" + form).length > 0) {
    var formObj = $('#' + form);
  } else if ($("." + form).length > 0) {
    var formObj = $('form.' + form);
  } else {
    var formObj = $("form");
  }
  if (!formObj || formObj.length < 1){
	  alert('参数错误！');
	  return;
  }
  if (!input_file || !input_file.files || input_file.files.length != 1 || !hiddenFieldId) {
    formObj.submit();
    return;
  } else {
    fetch("/api/users/image_server_url")
	.then(response =>response.text())
	.then(text =>JSON.parse(text)['server_url'])
	.then(server_url =>uploadAndSubmit(server_url))
	.catch(e =>{
	  alert("服务器连接失败，请重试！");
	  console.log("error:", e);
	});
    var uploadAndSubmit = function(avatar_server_url) {
      let formData = new FormData();
      let url = avatar_server_url;
	  formData.append("image", input_file.files[0]);
      fetch(url, {
        method: 'POST',
        mode: "cors",
        body: formData,
      }).then((response) =>response.text()).then((responseData) =>{
        console.log('responseData', responseData);
        img_url = JSON.parse(responseData)['image'];
        $('#' + hiddenFieldId).val(img_url);
        $('#' + fileFieldId).removeAttr('name');
        formObj.submit();
      }).
      catch((error) =>{
		alert("服务器连接失败，请重试！");
        console.error('error', error);
      });
    };
  }
}

function collectSimpleInfos() {
  let formData = new FormData();
  formData.append('users_behavior[requested_at]', new Date().format('yyyy-MM-dd hh:mm:ss'));
  $.post("/api/users/client_ip")
  .done(json => {
    formData.append('users_behavior[ip]', json.ip);
  })
  .always(obj=> {
    formData.append('users_behavior[from_url]', document.referrer);
    formData.append('users_behavior[request_url]', document.URL);
    formData.append('users_behavior[os]', platform.os.toString());
    formData.append('users_behavior[broswer]', platform.name + " " + platform.version);
    fetch('/api/users/users_behaviors', {
      body: formData,
      method: 'POST'
    })
    .then(response =>response.text())
    .then(text => JSON.parse(text))
    .then(json => lazyInfo.row_id = json.id);
  });
}

function askForGeoInfos(){
  if (navigator.geolocation){
      navigator.geolocation.getCurrentPosition(
      function (position){
        let lat = position.coords.latitude; //纬度
        let lag = position.coords.longitude; //经度
        lazyInfo.geo_position = lag+','+lat;
      } ,
      function (error){
        console.log(error.code);
     });
  }
  else{
    console.log("Broswer Don't Support GeoLocation!");
  }
}

function collectLazyInfos(){
  if(lazyInfo.row_id){
    let formData = new FormData();
    formData.append('users_behavior[left_at]', lazyInfo.left_at);
    formData.append('users_behavior[geo_position]', lazyInfo.geo_position);
    formData.append('users_behavior[click_positions]', lazyInfo.click_positions);
    fetch('/api/users/users_behaviors/'+lazyInfo.row_id, {
      body: formData,
      method: 'PATCH'
    });
  }
}
