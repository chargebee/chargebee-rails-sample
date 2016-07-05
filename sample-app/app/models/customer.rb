class Customer < ActiveRecord::Base
  include ChargebeeRails::Customer

  # Added by ChargebeeRails.
  has_one :subscription
  serialize :chargebee_data, JSON
end
