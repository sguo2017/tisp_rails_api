# == Schema Information
#
# 两种分类：好友和客户
# Table name: friends
#  id               :integer          not null, primary key
#  friend_id        :integer          desc: friend's user_id, is null when unregistered
#  friend_name			:string(255)
#  friend_num       :string(255)
#  user_id          :integer         desc: as a friend belong to user
#  status           :string          default: "unregistered"
#  catalog    			:string          default: "friend"

#状态（1）未注册（2）已推荐未激活（3）已激活（4）已锁定

class Friend < ApplicationRecord
	belongs_to :user
end
