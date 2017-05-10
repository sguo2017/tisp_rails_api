# == Schema Information
#
# Table name: users_behaviors
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  from_url        :string(255)
#  request_url     :string(255)
#  os              :string(255)
#  broswer         :string(255)
#  ip              :string(255)
#  geo_position    :string(255)
#  click_positions :string(255)
#  requested_at    :datetime
#  left_at         :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class UsersBehavior < ApplicationRecord
end
