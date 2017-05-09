class Const
  SUPER_ADMIN_ID = (1..10)
  IMAGE_UPLOAD_SERVLET_ADDRESS = "http://123.56.157.233:9090/FastDFSWeb/servlet/imageUploadServlet"
  PASSWORD_ERROR_LIMIT = 3
  USER_LEVELS = (1..3)
  DEFAULT_USER_LEVEL = 1
  ORDER_STATUS=[['已询价', '00A'], ['已报价', '00B'], ['已确定', '00C']]
  BOOLEAN_LIST=[['是', true], ['否', false]]
  #手机端短信验证码10分钟有效
  SMS_TIME_LIMIT=10
end