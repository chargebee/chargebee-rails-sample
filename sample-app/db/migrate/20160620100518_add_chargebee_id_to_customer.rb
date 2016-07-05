class AddChargebeeIdToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :chargebee_id, :string
    add_column :customers, :event_last_modified_at, :datetime
    add_column :customers, :chargebee_data, :text
  end
end
