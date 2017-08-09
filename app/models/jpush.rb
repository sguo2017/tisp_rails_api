class Jpush
  require 'net/http'
  require 'net/https'
  require "json"

  def Jpush.singleMsgPush(regId, msgContent, extras)
    uri = URI.parse("https: //api.jpush.cn/v3/push")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    @data = response.body
    return @data 
  end

  def Jpush.singleMsgPushV2(regId, msgContent, type)
    # exec "curl -X POST -v https: //api.jpush.cn/v3/push -H 'Content-Type: application/json' -u 'e0e54eb860345971931c8af9:#{regId}' -d  '{\"platform\":\"all\",\"audience\":\"all\",\"notification\":{\"alert\":\"#{msgContent}\"}}' ";
    system "curl -X POST -v https://api.jpush.cn/v3/push -H 'Content-Type: application/json' -u '550e59c50b9bb72ad34ab473:e0e54eb860345971931c8af9' -d  '{\"platform\":\"all\",\"audience\":{\"registration_id\" : [\"#{regId}\"]},\"notification\":{\"alert\":\"#{msgContent}\", \"android\":{\"extras\":{\"type\":\"#{type}\"}}}}' ";
  end

  def Jpush.allMsgPush(msgContent)
    system "curl -X POST -v https://api.jpush.cn/v3/push -H 'Content-Type: application/json' -u '550e59c50b9bb72ad34ab473:e0e54eb860345971931c8af9' -d  '{\"platform\":\"all\",\"audience\":\"all\",\"notification\":{\"alert\":\"#{msgContent}\"}}' ";
  end
end