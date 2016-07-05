class Subscription < ActiveRecord::Base
  belongs_to :customer
  belongs_to :plan
  has_one :payment_method
  include ChargebeeRails::Subscription
  serialize :chargebee_data, JSON
end
