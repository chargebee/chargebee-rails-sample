# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160620100518) do

  create_table "customers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "company"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "chargebee_id"
    t.datetime "event_last_modified_at"
    t.text     "chargebee_data"
  end

  create_table "event_sync_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string   "cb_customer_id"
    t.boolean  "auto_collection"
    t.string   "payment_type"
    t.string   "reference_id"
    t.string   "card_last4"
    t.string   "card_type"
    t.string   "status"
    t.datetime "event_last_modified_at"
    t.integer  "subscription_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "payment_methods", ["subscription_id"], name: "index_payment_methods_on_subscription_id"

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.string   "plan_id"
    t.string   "status"
    t.text     "chargebee_data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "chargebee_id"
    t.integer  "plan_id"
    t.integer  "plan_quantity",          default: 1
    t.integer  "customer_id"
    t.string   "status"
    t.datetime "event_last_modified_at"
    t.text     "chargebee_data"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "subscriptions", ["customer_id"], name: "index_subscriptions_on_customer_id"
  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id"

end
