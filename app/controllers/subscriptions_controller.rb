class SubscriptionsController < ApplicationController

  protect_from_forgery with: :null_session
  require 'stripe'

  def new
    # 以下コメントアウトは色々試したログとして残す
    # list customers
    # p Stripe::Customer.list()

    # p Stripe::Subscription.list()

    # @products =  Stripe::Product.list()
    
    # p Stripe::Plan.list()


    # p Stripe::Customer.list()

    # p Stripe::Price.retrieve(id: 'price_1J3cUSJGav40kD8bAJGVnfM6')

    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price: ENV['PRICE_A'],
        quantity: 1,
      }],
      mode: 'subscription',
      success_url: request.base_url + '/subscriptions/create_subscription?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: request.base_url + '/subscriptions/cancel_subscription',
    })

  end

  def new_maro
    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price: ENV['PRICE_B'],
        quantity: 1,
      }],
      mode: 'subscription',
      success_url: request.base_url + '/subscriptions/create_subscription?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: request.base_url + '/subscriptions/cancel_subscription',
    })

    render action: 'new'
  end

  def create_subscription
    @subscription_session = Stripe::Checkout::Session.retrieve(
      params[:session_id]
    )

    # ここで更新かけるの気持ち悪いなー
    user = User.find(current_user.id)
    user.update!(
      stripe_id: @subscription_session.customer,
      subscription_id: @subscription_session.subscription
    )
  end

  def cancel_subscription

  end

  def webhook
    payload = request.body.read
    event = nil
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET']
      )
    rescue JSON::ParserError => e
      # Invalid payload
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts '⚠️  Webhook signature verification failed.'
      status 400
      return
    end

    case event.type
    when 'customer.created'
      payment_intent = event.data.object
      p payment_intent
    when 'payment_method.attached'
      p 'hogehoge'
    else
      # Unexpected event type
      status 400
      return
    end
  
    status 200
  end

  # これでもできるけどcheckout Sessionの方が良さげ（記録として残す）
  def create_customer
    begin
      ActiveRecord::Base.transaction do
        card_token = params[:stripeToken]
        customer = Stripe::Customer.create({
          source: card_token,
        })        

        subscription = Stripe::Subscription.create(
          customer: customer['id'],
          items: [{
            plan: params[:subscription_price]
          }]
        )

        user = User.find(params[:user_id])
        user.update!(
          stripe_id: customer['id'],
          subscription_id: subscription['id']
        )
      end

      redirect_to root_path

    rescue => e
      p e
    end
  end

end
