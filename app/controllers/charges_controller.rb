class ChargesController < ApplicationController
  before_filter :authenticate_user!
  before_action :authorize_user
  before_action :set_payment_details

  def new
    Stripe.api_key = @user.secret_key
  end

  def thanks
    session[:payee_id], session[:amount] = nil, nil
  end

  def create
    Stripe.api_key = @user.secret_key
    customer = StripeTool.create_customer(email: params[:stripeEmail], 
                                          stripe_token: params[:stripeToken])

    charge = StripeTool.create_charge(customer_id: customer.id, 
                                      amount: @amount,
                                      description: @description)

    redirect_to thanks_path
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  private
    def authorize_user
      unless session[:amount] && session[:payee_id]
        redirect_to pay_messages_url, alert: 'Please select the payee.'
      end
    end

    def set_payment_details
      @amount = session[:amount]
      @user = User.find session[:payee_id]
      @description = "Pay to " + @user.full_name
    end
end