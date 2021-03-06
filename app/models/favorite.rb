# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  obj_id     :integer
#  obj_type   :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Favorite < ApplicationRecord
	belongs_to :good, counter_cache: true
	belongs_to :user, counter_cache: true
end
