class PaymentMethod < ActiveRecord::Base
  belongs_to :subscription
end
