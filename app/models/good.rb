# == Schema Information
#
# Table name: goods
#
#  id            :integer          not null, primary key
#  serv_title    :string(255)
#  serv_detail   :string(255)
#  serv_imges    :string(255)
#  serv_catagory :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#  catalog       :string(255)
#

class Good < ApplicationRecord
  has_ancestry
  belongs_to :user
end
