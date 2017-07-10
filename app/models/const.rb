class Const
  GOODS_CATALOG_ROOT_ID = 1
  SUPER_ADMIN_ID = (1..10)
  IMAGE_UPLOAD_SERVLET_ADDRESS = "http://123.56.157.233:9090/FastDFSWeb/servlet/imageUploadServlet"
  PASSWORD_ERROR_LIMIT = 3
  USER_LEVELS = (1..3)
  DEFAULT_USER_LEVEL = 1
  ORDER_STATUS={:inquiried => 'inquiried', :offered => 'offered', :confirmed => 'confirmed'}
  ORDER_STATUS_TRANSLATE={:inquiried => '已询价', :offered => '已报价', :confirmed => '已确定'}
  BOOLEAN_LIST=[['是', true], ['否', false]]
  #清理搜索记录的时间周期 1s 1m 1h 1d
  CLEAN_SEARCH_INTERVAL = '1h'
  #手机端短信验证码10分钟有效
  SMS_TIME_LIMIT=10
  TOKEN_TIME_LIMIT=1
  MAILER_ACCOUNT = "qike2018qike@163.com"
  MAILER_PASSWORD = "tispr2017" # 如果是开了邮箱授权码，要用授权码代替密码
  GOODS_TYPE = {:request => "serv_request", :offer => "serv_offer"}
  GOODS_TYPE_TRANSLATE = {:request => "正向商品", :offer => "逆向商品"}
  SERV_QRY_TYPE = {:offer => "1", :request => "2"}  #good或offer查詢類型
  SERV_VIA = {:local => "local", :remote => "remote", :all => "all"} #服务方式 本地|远程|全部
  REQUEST_ORDERS_LIMIT = 2   #需求订单数限制
  USER_PROFILE ="大家好，我来自%s，请多多关照"

  
  module SysMsg
    SYSTEM_USER_ID = 1
    GOODS_TYPE = {:request => "serv_request", :offer => "serv_offer"}
    GOODS_TYPE_TRANSLATE = {:serv_request => "正向商品", :serv_offer => "逆向商品"}
    CATALOG = {:private => "private", :system => "system", :public => "public"}
    CATALOG_TRANSLATE = {:private => "私有消息", :system => "系统消息", :public => "公共消息"}
    STATUS = {:created => "created", :unread => "unread", :read => "read", :discarded => "discarded", :finished => "finished"}
    STATUS_TRANSLATE = {:created => "已创建", :unread => "未读", :read => "已读", :discarded => "已丢弃"}
    ORDER_STATUS = {:inquiried => "inquiried", :offered => "offered" ,:confirmed => "confirmed"}
    ORDER_STATUS_TRANSLATE = {:inquiried => "已询价", :offered => "已报价" ,:confirmed => "已确定"}
    ACCEPT_USERS_TYPE = {:same_city => "same_city", :specify_cities => "specify_cities", :specify_users => "specify_users", :all => "all"}
    ACCEPT_USERS_TYPE_TRANSLATE = {:same_city => "同城", :specify_cities => "指定区域", :specify_users => "指定用户", :all => "所有人"}
    ACTION_TITLE_OF_REGISTRATION = "加入奇客"
    ACTION_TITLE_OF_USER_CREATE_SERV_OFFER = "发布了一项专业服务"
    ACTION_TITLE_OF_REQUEST_ORDER = "正在与__%s__沟通一个工作机会"
    ACTION_TITLE_OF_OFFERED_ORDER = "正在了解__%s__的服务"
    ACTION_TITLE_OF_CONFIRMED_ORDER ="与__%s__达成一个工作机会"

  end

end
