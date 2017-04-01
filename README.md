## 为devise添加token认证[用curl发送请求举例]：

# 使用方法

  ##需要token认证的
  before_filter :authenticate_user_from_token!
  
  ##需要正常的cookie认证的
  before_filter :authenticate_user!

# 注册

curl -X POST -H 'Content-Type: application/json' -d '{"user":{"password":"12345678","password_confirmation":"12345678","email": "12345678@x.com"}}' http://localhost:3000/users.json

# 登录

curl -X POST -H 'Content-Type: application/json' -d '{"user":{"email": "12345678@x.com","password": "12345678"}}' http://localhost:3000/users/sign_in

  
# serv_offer新增
curl -X POST -H "Content-Type: application/json" -d '{"serv_offer":{"serv_title":"title_test******","serv_detail":"detail_test******"}}' localhost:3000/serv_offers.json?[token](#token)=d653DiN4154_eUgti_q-

参考：
http://www.tuicool.com/articles/RBVf22
