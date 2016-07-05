class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :cb_customer_id
      t.boolean :auto_collection
      t.string :payment_type
      t.string :reference_id
      t.string :card_last4
      t.string :card_type
      t.string :status
      t.datetime :event_last_modified_at
      t.references :subscription, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
