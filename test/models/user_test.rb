# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(255)
#  name                   :string(255)
#  avatar                 :string(255)
#  admin                  :boolean          default(FALSE)
#  num                    :string(255)
#  level                  :integer          default(1)
#  lock                   :integer          default(0)
#  district               :string(255)
#  city                   :string(255)
#  province               :string(255)
#  country                :string(255)
#  latitude               :string(255)
#  longitude              :string(255)
#  profile                :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
