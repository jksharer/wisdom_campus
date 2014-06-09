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

ActiveRecord::Schema.define(version: 20140608093921) do

  create_table "agencies", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "higher_agency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "school_type_id"
    t.string   "address"
    t.string   "header"
  end

  add_index "agencies", ["school_type_id"], name: "index_agencies_on_school_type_id"

  create_table "agencies_menus", id: false, force: true do |t|
    t.integer  "agency_id"
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "announcements", force: true do |t|
    t.string   "name"
    t.string   "announcement_type"
    t.text     "content"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "procedure_id"
    t.string   "state",             default: "initial"
  end

  add_index "announcements", ["procedure_id"], name: "index_announcements_on_procedure_id"
  add_index "announcements", ["user_id"], name: "index_announcements_on_user_id"

  create_table "behavior_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "score"
    t.integer  "agency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "behaviors", force: true do |t|
    t.integer  "student_id"
    t.integer  "behavior_type_id"
    t.datetime "time"
    t.string   "address"
    t.string   "description"
    t.integer  "score"
    t.integer  "confirm_state",    default: 0
    t.integer  "recorder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
    t.integer  "serial_number"
  end

  add_index "behaviors", ["agency_id"], name: "index_behaviors_on_agency_id"

  create_table "class_roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_roles_students", id: false, force: true do |t|
    t.integer  "class_role_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "agency_id"
    t.integer  "parent_department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments", ["agency_id"], name: "index_departments_on_agency_id"

  create_table "estimate_rules", force: true do |t|
    t.integer  "lower"
    t.integer  "higher"
    t.string   "description"
    t.integer  "agency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "estimate_rules", ["agency_id"], name: "index_estimate_rules_on_agency_id"

  create_table "grades", force: true do |t|
    t.string   "name"
    t.integer  "school_type_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
  end

  add_index "grades", ["agency_id"], name: "index_grades_on_agency_id"
  add_index "grades", ["school_type_id"], name: "index_grades_on_school_type_id"

  create_table "iclasses", force: true do |t|
    t.string   "name"
    t.integer  "grade_id"
    t.string   "header"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
  end

  add_index "iclasses", ["agency_id"], name: "index_iclasses_on_agency_id"
  add_index "iclasses", ["grade_id"], name: "index_iclasses_on_grade_id"

  create_table "menus", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "status"
    t.integer  "display_order"
    t.integer  "parent_menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "controller"
    t.string   "action"
    t.string   "icon"
  end

  create_table "menus_roles", id: false, force: true do |t|
    t.integer  "menu_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menus_roles", ["menu_id", "role_id"], name: "index_menus_roles_on_menu_id_and_role_id", unique: true
  add_index "menus_roles", ["menu_id"], name: "index_menus_roles_on_menu_id"
  add_index "menus_roles", ["role_id"], name: "index_menus_roles_on_role_id"

  create_table "procedures", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
  end

  add_index "procedures", ["agency_id"], name: "index_procedures_on_agency_id"

  create_table "projects", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "description"
    t.integer  "department_id"
    t.string   "priority",      default: "1"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status",        default: "0"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["department_id"], name: "index_projects_on_department_id"
  add_index "projects", ["user_id"], name: "index_projects_on_user_id"

  create_table "reviews", force: true do |t|
    t.string   "model_type"
    t.integer  "object_id"
    t.integer  "step_id"
    t.string   "state",      default: "initial"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["object_id"], name: "index_reviews_on_object_id"
  add_index "reviews", ["step_id"], name: "index_reviews_on_step_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_id"
  end

  add_index "roles", ["agency_id"], name: "index_roles_on_agency_id"

  create_table "school_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "semesters", force: true do |t|
    t.string   "name"
    t.integer  "school_year"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "current"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms", force: true do |t|
    t.string   "mid"
    t.string   "phone"
    t.string   "content"
    t.datetime "send_time"
    t.string   "status"
    t.integer  "behavior_id"
    t.integer  "agency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "steps", force: true do |t|
    t.integer  "view_order"
    t.integer  "user_id"
    t.integer  "procedure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "steps", ["procedure_id"], name: "index_steps_on_procedure_id"
  add_index "steps", ["user_id"], name: "index_steps_on_user_id"

  create_table "students", force: true do |t|
    t.string   "sid"
    t.string   "name"
    t.integer  "gender",        limit: 255, default: 0
    t.string   "photo"
    t.integer  "iclass_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "class_role_id"
    t.integer  "agency_id"
    t.string   "id_number"
    t.string   "class_name"
    t.string   "card_type"
    t.string   "card_status"
    t.datetime "open_date"
    t.string   "bank_account"
    t.integer  "phone"
  end

  add_index "students", ["agency_id"], name: "index_students_on_agency_id"
  add_index "students", ["class_role_id"], name: "index_students_on_class_role_id"
  add_index "students", ["iclass_id"], name: "index_students_on_iclass_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.integer  "agency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
  end

  add_index "users", ["agency_id"], name: "index_users_on_agency_id"
  add_index "users", ["department_id"], name: "index_users_on_department_id"

  create_table "users_roles", id: false, force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_roles", ["role_id"], name: "index_users_roles_on_role_id"
  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", unique: true
  add_index "users_roles", ["user_id"], name: "index_users_roles_on_user_id"

end
