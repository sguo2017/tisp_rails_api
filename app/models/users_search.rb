class UsersSearch < ApplicationRecord
  def users
    @users ||= find_users
  end
  
  private
    # 条件搜索
    def find_users
	    users=User.all
		users=users.where("`id` = ? ",user_id) if user_id.present?
		users=users.where("`email` like ? ","%#{user_email}%") if user_email.present?
		users=users.where("`name` like ? ","%#{user_name}%") if user_name.present?
		users=users.where("`admin` = ? ",is_admin) if is_admin.present?
		users=users.where("`level` = ? ",user_level) if user_level.present?
		if !has_locked.nil? and has_locked
		  users=users.where("`admin` = ? and `updated_at` >= ? and `lock` >= ? ", false, Time.now.beginning_of_day, Const::PASSWORD_ERROR_LIMIT)
		elsif !has_locked.present? and !has_locked
		  users=users.where.not("`admin` = ? and `updated_at` >= ? and `lock` >= ? ", false, Time.now.beginning_of_day, Const::PASSWORD_ERROR_LIMIT)
		end
		users=users.where("`created_at` like ? ","%#{user_created}%") if user_created.present?
		return users
	end
end
