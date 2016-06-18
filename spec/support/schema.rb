ActiveRecord::Schema.define do
  self.verbose = false

  create_table 'posts', force: :cascade do |t|
    t.string   'image'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
