## 用curl发送请求举例：

# 注册
curl -X POST -H 'Content-Type: application/json' -d '{"user":{"password":"12345678","password_confirmation":"12345678","email": "12345678@x.com"}}' http://localhost:3000/users.json

# 登录
curl -X POST -H 'Content-Type: application/json' -d '{"user":{"email": "12345678@x.com","password": "12345678"}}' http://localhost:3000/users/sign_in

# 使用方法
  ##需要token认证的
  before_filter :authenticate_user_from_token!
  ##需要正常的cookie认证的
  before_filter :authenticate_user!
  
  
  

参考：
https://ruby-china.org/topics/25822
