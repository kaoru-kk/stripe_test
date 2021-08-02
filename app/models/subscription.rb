class Subscription < ApplicationRecord

  require 'stripe'

  def self.create_customer

  end

  def self.subscribe(customer_id:, plan_id:)
    Stripe::Subscription.create({
      customer: customer_id,
      items: [{ plan: plan_id }],
    })
  end
  
end
