class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
	#超级管理员,无限制
	if user.admin and Const::SUPER_ADMIN_ID.include?(user.id)
	   can :manage, :all
	end
	#普通管理员，只能查看所有东西
    if user.admin
      can :read, :all
    end
	#限制用户添加商品的数量
	if avaliable_goods_to_add(user) > 0
	  can :create, Good
	end

  end

  def avaliable_goods_to_add(user)
    has_added = user.goods.where("created_at >= ?", Time.now.beginning_of_day).size
	limit = 0
    limit = 10 if user.level == 1
	limit = 20 if user.level == 2
	limit = 30 if user.level == 3
	limit = has_added + 1 if user.admin #管理员无限制
	avaliable=limit - has_added
	return avaliable
  end

end
