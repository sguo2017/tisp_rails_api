class FriendSerializer < ActiveModel::Serializer
  attributes :id, :friend_id, :friend_name, :friend_num, :user_id, :status
end
