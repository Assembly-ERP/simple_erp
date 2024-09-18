# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_17_162344) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "brandings", force: :cascade do |t|
    t.string "name", null: false
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "ein"
    t.string "phone"
    t.string "primary_color", null: false
    t.string "primary_text_color", null: false
    t.string "secondary_color", null: false
    t.string "secondary_text_color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_id", null: false
    t.bigint "part_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["part_id"], name: "index_cart_items_on_part_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone"
    t.string "ein"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.decimal "discount", precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_customers_on_name", unique: true
  end

  create_table "invitations", force: :cascade do |t|
    t.string "email"
    t.string "token"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_invitations_on_customer_id"
  end

  create_table "order_assignees", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_assignees_on_order_id"
    t.index ["user_id"], name: "index_order_assignees_on_user_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id"
    t.bigint "part_id"
    t.integer "quantity", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.boolean "override", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["part_id"], name: "index_order_details_on_part_id"
    t.index ["product_id"], name: "index_order_details_on_product_id"
    t.check_constraint "product_id IS NOT NULL OR part_id IS NOT NULL", name: "product_or_part_present_check"
  end

  create_table "order_id_formats", force: :cascade do |t|
    t.string "format", null: false
    t.boolean "active", default: false, null: false
    t.string "example"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["format"], name: "index_order_id_formats_on_format", unique: true
  end

  create_table "order_price_schedulers", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_shipping_addresses", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "name", default: ""
    t.string "phone", default: ""
    t.string "street", default: ""
    t.string "city", default: ""
    t.string "state", default: ""
    t.string "zip_code", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_shipping_addresses_on_order_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "customer_locked", default: false, null: false
    t.boolean "operation_locked", default: false, null: false
    t.boolean "reversed", default: false, null: false
    t.boolean "default", default: false, null: false
    t.boolean "allow_change", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0"
    t.bigint "order_status_id", null: false
    t.decimal "shipping_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "discount_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.decimal "tax", precision: 10, scale: 2, default: "0.0"
    t.datetime "voided_at"
    t.datetime "last_scheduled", default: -> { "now()" }
    t.boolean "send_quote_assignees", default: true, null: false
    t.integer "holder_id"
    t.string "formatted_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["formatted_id"], name: "index_orders_on_formatted_id", unique: true
    t.index ["last_scheduled"], name: "index_orders_on_last_scheduled"
    t.index ["order_status_id"], name: "index_orders_on_order_status_id"
    t.index ["voided_at"], name: "index_orders_on_voided_at"
  end

  create_table "parts", force: :cascade do |t|
    t.string "name", null: false
    t.string "sku"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.integer "in_stock", default: 0
    t.decimal "weight", precision: 10, scale: 2, default: "0.0"
    t.decimal "length", precision: 10, scale: 2, default: "0.0"
    t.decimal "width", precision: 10, scale: 2, default: "0.0"
    t.json "json_attributes"
    t.boolean "manual_price", default: false, null: false
    t.boolean "inventory", default: false, null: false
    t.datetime "voided_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["voided_at"], name: "index_parts_on_voided_at"
  end

  create_table "parts_products", force: :cascade do |t|
    t.bigint "part_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id", "product_id"], name: "index_parts_products_on_part_id_and_product_id", unique: true
    t.index ["part_id"], name: "index_parts_products_on_part_id"
    t.index ["product_id"], name: "index_parts_products_on_product_id"
  end

  create_table "poly_attributes", force: :cascade do |t|
    t.string "attributable_type", null: false
    t.bigint "attributable_id", null: false
    t.string "input_type", default: "text", null: false
    t.string "value", null: false
    t.string "label", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attributable_type", "attributable_id"], name: "index_poly_attributes_on_attributable"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "sku"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.decimal "weight", precision: 10, scale: 2, default: "0.0"
    t.boolean "available", default: false, null: false
    t.json "json_attributes"
    t.datetime "voided_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["voided_at"], name: "index_products_on_voided_at"
  end

  create_table "settings", force: :cascade do |t|
    t.string "key", null: false
    t.string "code", null: false
    t.decimal "value", precision: 10, scale: 2, default: "0.0"
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key", "code"], name: "index_settings_on_key_and_code", unique: true
  end

  create_table "support_ticket_messages", force: :cascade do |t|
    t.bigint "support_ticket_id", null: false
    t.bigint "user_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["support_ticket_id"], name: "index_support_ticket_messages_on_support_ticket_id"
    t.index ["user_id"], name: "index_support_ticket_messages_on_user_id"
  end

  create_table "support_tickets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "issue_description", null: false
    t.string "status", default: "pending", null: false
    t.bigint "customer_id"
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_support_tickets_on_customer_id"
    t.index ["user_id"], name: "index_support_tickets_on_user_id"
  end

  create_table "transporters", force: :cascade do |t|
    t.string "name"
    t.string "contact_info"
    t.json "api_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.bigint "customer_id"
    t.string "role", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["customer_id"], name: "index_users_on_customer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "url"
    t.string "secret_token"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_webhooks_on_customer_id"
    t.index ["user_id"], name: "index_webhooks_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "parts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "invitations", "customers"
  add_foreign_key "order_assignees", "orders"
  add_foreign_key "order_assignees", "users"
  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "parts"
  add_foreign_key "order_details", "products"
  add_foreign_key "order_shipping_addresses", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "order_statuses"
  add_foreign_key "parts_products", "parts"
  add_foreign_key "parts_products", "products"
  add_foreign_key "support_ticket_messages", "support_tickets"
  add_foreign_key "support_ticket_messages", "users"
  add_foreign_key "support_tickets", "customers"
  add_foreign_key "support_tickets", "users"
  add_foreign_key "users", "customers"
  add_foreign_key "webhooks", "customers"
  add_foreign_key "webhooks", "users"
end
