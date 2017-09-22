# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170922011608) do

  create_table "chat_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "message",      limit: 65535
    t.integer  "chat_room_id"
    t.integer  "user_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "status",                     default: "unread"
    t.index ["chat_room_id"], name: "index_chat_messages_on_chat_room_id", using: :btree
    t.index ["user_id"], name: "index_chat_messages_on_user_id", using: :btree
  end

  create_table "chat_rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "deal_id"
    t.index ["recipient_id"], name: "index_chat_rooms_on_recipient_id", using: :btree
    t.index ["sender_id"], name: "index_chat_rooms_on_sender_id", using: :btree
  end

  create_table "chats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "deal_id"
    t.string   "chat_content"
    t.integer  "user_id"
    t.string   "catalog"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "status",          default: "unread"
    t.integer  "receive_user_id"
  end

  create_table "chats_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "chat_id"
    t.integer  "order_id"
    t.string   "chat_content"
    t.integer  "user_id"
    t.string   "chat_catalog"
    t.string   "chat_created"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "obj_id"
    t.integer  "user_id"
    t.string   "obj_type"
    t.string   "content"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "status",     default: "good"
  end

  create_table "favorites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "obj_id"
    t.string   "obj_type"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "good_id"
  end

  create_table "favorites_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "favor_id"
    t.integer  "obj_id"
    t.string   "obj_type"
    t.integer  "user_id"
    t.string   "favor_created"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "friends", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "friend_id"
    t.string   "friend_name"
    t.string   "friend_num"
    t.integer  "user_id"
    t.string   "status",      default: "unregistered"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "catalog",     default: "friend"
  end

  create_table "goods", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "serv_title"
    t.string   "serv_detail"
    t.string   "serv_images",      limit: 2000
    t.string   "serv_catagory"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "user_id"
    t.string   "catalog"
    t.integer  "goods_catalog_id"
    t.string   "district"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "favorites_count"
    t.string   "via",                           default: "local"
    t.integer  "orders_count",                  default: 0
    t.integer  "order_cnt",                     default: 0
    t.string   "status",                        default: "00A"
    t.integer  "reports_count",                 default: 0
    t.integer  "range",                         default: 0
  end

  create_table "goods_catalogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "image"
    t.integer  "level"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "ancestry"
    t.integer  "goods_count",   default: 0
    t.integer  "request_count", default: 0
    t.index ["ancestry"], name: "index_goods_catalogs_on_ancestry", using: :btree
  end

  create_table "goods_catalogs_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "catalog_id"
    t.string   "catalog_name"
    t.integer  "catalog_level"
    t.string   "catalog_parent"
    t.integer  "goods_count"
    t.string   "catalog_created"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "goods_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "serv_id"
    t.integer  "user_id"
    t.string   "serv_title"
    t.string   "serv_detail"
    t.string   "serv_catagory"
    t.string   "serv_created"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "invitations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "status",     default: "00A"
    t.integer  "count",      default: 0
    t.string   "code"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "order_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "deal_id"
    t.integer  "serv_offer_id"
    t.string   "serv_offer_user_name"
    t.string   "serv_offer_titile"
    t.string   "lately_chat_content"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "offer_user_id"
    t.integer  "request_user_id"
    t.integer  "bidder"
    t.integer  "signature"
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "serv_offer_title"
    t.integer  "serv_offer_id"
    t.integer  "offer_user_id"
    t.integer  "request_user_id"
    t.string   "status"
    t.datetime "connect_time"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "lately_chat_content"
    t.integer  "bidder"
    t.integer  "signature"
    t.string   "serv_catagory"
  end

  create_table "orders_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order_id"
    t.string   "serv_offer_title"
    t.integer  "serv_offer_id"
    t.integer  "offer_user_id"
    t.integer  "request_user_id"
    t.string   "status"
    t.string   "connect_time"
    t.integer  "bidder"
    t.integer  "signature"
    t.string   "order_created"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "obj_id"
    t.string   "obj_type"
    t.string   "content"
    t.string   "status",                  default: "unread"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "image",      limit: 2000
    t.string   "tag"
    t.integer  "user_id"
  end

  create_table "sms_sends", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "recv_num"
    t.string   "send_content"
    t.string   "state"
    t.string   "sms_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
  end

  create_table "sms_sends_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sms_id"
    t.string   "recv_num"
    t.string   "send_content"
    t.string   "state"
    t.string   "sms_type"
    t.string   "user_name"
    t.string   "sms_created"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "suggestions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "content"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sys_msgs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "user_name"
    t.string   "action_title"
    t.string   "action_desc"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "serv_id"
    t.string   "interval"
    t.string   "msg_catalog"
    t.string   "accept_users_type"
    t.string   "status"
    t.string   "via"
    t.string   "district"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.integer  "goods_catalog_id"
    t.integer  "link_user_id"
    t.integer  "order_id"
    t.string   "link_user_name"
  end

  create_table "sys_msgs_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sys_id"
    t.string   "user_name"
    t.string   "action_title"
    t.string   "action_desc"
    t.integer  "user_id"
    t.integer  "serv_id"
    t.string   "sys_created"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "sys_msgs_timelines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sys_msg_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
    t.index ["user_id"], name: "index_sys_msgs_timelines_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "authentication_token"
    t.string   "name"
    t.string   "avatar"
    t.boolean  "admin",                  default: false
    t.string   "num"
    t.integer  "level",                  default: 1
    t.integer  "lock",                   default: 0
    t.string   "district"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "profile"
    t.integer  "favorites_count",        default: 0
    t.integer  "request_count",          default: 0
    t.integer  "offer_count",            default: 0
    t.boolean  "switch_to",              default: true
    t.string   "call_from"
    t.string   "call_to"
    t.string   "website"
    t.integer  "reports_count",          default: 0
    t.string   "regist_id"
    t.string   "device_type"
    t.string   "status",                 default: "00A"
    t.integer  "village_id"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_behaviors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "from_url"
    t.string   "request_url"
    t.string   "os"
    t.string   "broswer"
    t.string   "ip"
    t.string   "geo_position"
    t.string   "click_positions"
    t.datetime "requested_at"
    t.datetime "left_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "user_email"
    t.string   "user_name"
    t.boolean  "is_admin"
    t.integer  "user_level"
    t.boolean  "has_locked"
    t.string   "user_created"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users_villages", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "village_id"
    t.index ["user_id"], name: "index_users_villages_on_user_id", using: :btree
    t.index ["village_id"], name: "index_users_villages_on_village_id", using: :btree
  end

  create_table "villages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.float    "latitude",    limit: 24
    t.float    "longitude",   limit: 24
    t.string   "district"
    t.string   "postal_code"
    t.string   "avatar"
  end

  create_table "villages_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "village_id"
    t.index ["user_id"], name: "index_villages_users_on_user_id", using: :btree
    t.index ["village_id"], name: "index_villages_users_on_village_id", using: :btree
  end

  add_foreign_key "chat_messages", "chat_rooms"
  add_foreign_key "chat_messages", "users"
end
