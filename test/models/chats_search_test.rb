# == Schema Information
#
# Table name: chats_searches
#
#  id           :integer          not null, primary key
#  chat_id      :integer
#  order_id     :integer
#  chat_content :string(255)
#  user_id      :integer
#  chat_catalog :string(255)
#  chat_created :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ChatsSearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
