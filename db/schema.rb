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

ActiveRecord::Schema.define(version: 20170421012708) do

  create_table "deal_chat_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "deal_id"
    t.string   "chat_content"
    t.integer  "user_id"
    t.string   "catalog"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "deal_chats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "deal_id"
    t.integer  "serv_offer_id"
    t.string   "serv_offer_user_name"
    t.string   "serv_offer_titile"
    t.string   "lately_chat_content"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "offer_user_id"
    t.integer  "request_user_id"
  end

  create_table "deals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "serv_offer_title"
    t.integer  "serv_offer_id"
    t.integer  "offer_user_id"
    t.integer  "request_user_id"
    t.string   "status"
    t.datetime "connect_time"
    t.datetime "deal_time"
    t.datetime "finish_time"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "lately_chat_content"
  end

  create_table "favorites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "obj_id"
    t.string   "obj_type"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "serv_offers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "serv_title"
    t.string   "serv_detail"
    t.string   "serv_imges"
    t.string   "serv_catagory"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
  end

  create_table "serv_offers_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "serv_id"
    t.integer  "user_id"
    t.string   "serv_title"
    t.string   "serv_detail"
    t.string   "serv_category"
    t.string   "serv_created"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "sys_msgs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "user_name"
    t.string   "action_title"
    t.string   "action_desc"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "serv_id"
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
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
