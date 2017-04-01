##用curl发送请求举例：
#注册
curl -X POST -H 'Content-Type: application/json' -d '{"user":{"password":"12345678","password_confirmation":"12345678","email": "12345678@x.com"}}' http://localhost:3000/users.json

#登录
curl -X POST -H 'Content-Type: application/json' -d '{"user":{"email": "12345678@x.com","password": "12345678"}}' http://localhost:3000/users/sign_in



参考：
https://ruby-china.org/topics/25822
