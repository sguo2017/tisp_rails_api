# == Schema Information
#
# Table name: comments
#  id                     :integer          not null, primary key
# user_id									:integer
# obj_id									:integer
# obj_type								:string
# content									:string
class Comment < ApplicationRecord
	belongs_to :user
end
