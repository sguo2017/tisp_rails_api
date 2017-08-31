class CommentSerializer < ActiveModel::Serializer
  attributes :id, :obj_id, :user_id, :obj_type, :content
end
