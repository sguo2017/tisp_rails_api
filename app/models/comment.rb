# == Schema Information
#
# Table name: comments
#  id                     :integer          not null, primary key
# user_id									:integer
# obj_id									:integer
# obj_type								:string
# content									:string
class Comment < ApplicationRecord
	belongs_to :good, counter_cache: true
	belongs_to :user, counter_cache: true
end
