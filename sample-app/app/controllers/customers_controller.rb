class CustomersController < ApplicationController
  before_filter :new_customer, only: [:new, :hosted_page_sign_up, :stripe_sign_up]
  
  def hosted_page_sign_up
  end

  def stripe_sign_up
  end

  def new
  end

  def subscription_without_card
    Customer.transaction do
      @customer = Customer.create(customer_params)
      @customer.subscribe(customer: customer_params)
      redirect_to customers_path
    end
  end

  def hosted_page_checkout_new
    hosted_page = ChargeBee::HostedPage.checkout_new(
      subscription: { plan_id: params[:plan_id] },
      card: {gateway: "chargebee"},
      customer: customer_params,
      embed: true,
      iframe_messaging: true
    ).hosted_page
    render json: {
      url: hosted_page.url,
      hosted_page_id: hosted_page.id,
      site_name: ENV["CHARGEBEE_SITE"]
    }
  end

  def hosted_page_checkout_existing
    @customer = Customer.find(params[:id])
    hosted_page = ChargeBee::HostedPage.checkout_existing(
      subscription: { id: @customer.subscription.chargebee_id, plan_id: @customer.subscription.plan.plan_id, trial_end: 0 },
      card: {gateway: "chargebee"},
      embed: true,
      iframe_messaging: true 
    ).hosted_page

    render json: {
      url: hosted_page.url,
      hosted_page_id: hosted_page.id,
      site_name: ENV["CHARGEBEE_SITE"]
    }
  end


  def change_subscription
    @customer = Customer.find(params[:customer][:id])
    @customer.update_subscription(plan_id: params[:plan_id], coupon: params[:coupon_id])
    redirect_to customers_path
  end

  def checkout_new
    Customer.transaction do
      @customer = Customer.create(customer_params)
      tmp_token = params[:payment_gateway] == 'Stripe' ? params[:stripeToken] : params[:braintreeToken]
      @customer.subscribe(
        {
          plan_id: params[:plan_id],
          skip_trial: params[:skip_trial],
          customer: customer_params,
          card: {
            gateway: params[:payment_gateway],
            tmp_token: tmp_token
          }
        }
      )
      render json: {success: true, forward: request.base_url+customers_path}
    end
  end

  def checkout_existing
    @customer = Customer.find(params[:id])
    @subscriber = @customer.as_chargebee_customer
    tmp_token = params[:payment_gateway] == "stripe" ? params[:stripeToken] : params[:braintreeToken]
    @customer.update_subscription(card: { gateway: params[:payment_gateway], tmp_token: tmp_token })
    render json: {success: true, forward: request.base_url+customers_path}
  end

  def subscribe
    hosted_page = ChargeBee::HostedPage.retrieve(params[:hosted_page_id]).hosted_page
    hosted_page_customer = hosted_page.content.customer
    @customer = Customer.create(
      first_name: hosted_page_customer.first_name,
      last_name: hosted_page_customer.last_name,
      phone: hosted_page_customer.phone,
      email: hosted_page_customer.email
    )
    @customer.subscribe_via_hosted_page(hosted_page)
    redirect_to customers_path
  end

  def activate_subscription
    hosted_page = ChargeBee::HostedPage.retrieve(params[:hosted_page_id]).hosted_page
    @customer = Customer.find_by(chargebee_id: hosted_page.content.customer.id)
    @customer.update_subscription_via_hosted_page(hosted_page)
    redirect_to customers_path
  end

  def index
    @customers = Customer.all.includes(subscription: [:plan])
  end

  def show
    @customer = Customer.find(params[:id])
    @subscriber = @customer.as_chargebee_customer
  end

  def cancel_subscription
    @customer = Customer.find_by(chargebee_id: params[:id])    
    @customer.subscription.cancel({ end_of_term: params[:end_of_term] })
    redirect_to customers_path
  end

  def add_plan
    @customer = Customer.find(params[:id])
    @subscriber = @customer.as_chargebee_customer
    @coupon_list = ChargeBee::Coupon.list(status: 'active')
    subscription = @customer.subscription.as_chargebee_subscription
    @coupons = subscription.coupons if subscription.present? && subscription.coupons.present?
  end

  def estimation
    customer = Customer.find(params[:customer_id])
    estimate = Subscription.estimate_changes(
      subscription: { 
        id: customer.subscription.chargebee_id, 
        plan_id: params[:plan_id], 
        coupon_id: params[:coupon_id]
    })
    render json: { subscription_estimate: estimate.subscription_estimate, invoice_estimate: estimate.invoice_estimate, next_invoice_estimate: estimate.next_invoice_estimate }
  end

  private

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :company)
  end

  def new_customer
    @customer = Customer.new
  end
end
