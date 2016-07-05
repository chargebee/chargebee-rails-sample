class EventsController < ChargebeeRails::WebhooksController
  
  # Here we can do things like notifying customer through mail
  # about new subscription with the application
  def subscription_created
    puts event
  end
end
