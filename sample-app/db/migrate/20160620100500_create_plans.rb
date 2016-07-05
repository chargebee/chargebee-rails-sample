class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :plan_id
      t.string :status
      t.text :chargebee_data

      t.timestamps null: false
    end
  end
end
