class GoodsCatalogsSearch < ApplicationRecord
  def goods_catalogs
    @goods_catalogs ||= find_goods_catalogs
  end
  
  private
    # 条件搜索
    def find_goods_catalogs
	    goods_catalogs=GoodsCatalog.all
		goods_catalogs=goods_catalogs.where("id= ? ",catalog_id) if catalog_id.present?
		goods_catalogs=goods_catalogs.where("`name` like ? ","%#{catalog_name}%") if catalog_name.present?
		goods_catalogs=goods_catalogs.where("level= ? ",catalog_level) if catalog_level.present?
		goods_catalogs=goods_catalogs.where("goods_count = ? ","%#{goods_count}%") if goods_count.present?
		goods_catalogs=goods_catalogs.where("created_at like ? ","%#{catalog_created}%") if catalog_created.present?
		if catalog_parent.present?
		   #父节点名称匹配对应的id数组
		   pids=GoodsCatalog.all.where("name like ? ","%#{catalog_parent}%").map{|x| x.id}
		   #查找出父节点是对应id的分类对象，并转换为id数组
		   goods_catalogs_ids=goods_catalogs.select{|x| pids.include? x.parent_id }.map{|x| x.id}
		   #根据id数组做子集查询
		   goods_catalogs=goods_catalogs.where(:id => goods_catalogs_ids)
		end
		return goods_catalogs
	end
end
