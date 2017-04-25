# == Schema Information
#
# Table name: favorites_searches
#
#  id            :integer          not null, primary key
#  favor_id      :integer
#  obj_id        :integer
#  obj_type      :string(255)
#  user_id       :integer
#  favor_created :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class FavoritesSearch < ApplicationRecord
  def favorites
    @favorites ||= find_favorites
  end
  
  private
    # 条件搜索
    def find_favorites
	    favorites=Favorite.all
		favorites=favorites.where("id= ? ",favor_id) if favor_id.present?
		favorites=favorites.where("obj_id= ? ",obj_id) if obj_id.present?
		favorites=favorites.where("obj_type like ? ","%#{obj_type}%") if obj_type.present?
		favorites=favorites.where("user_id= ? ",user_id) if user_id.present?
		favorites=favorites.where("created_at like ? ","%#{favor_created}%") if favor_created.present?
		return favorites
	end
end
