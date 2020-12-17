class MarketplaceOrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]

  # GET /marketplace_orders
  def index
    @orders = Order.all
  end

  # GET /marketplace_orders/1
  def show; end

  # GET /marketplace_orders/new
  def new
    payment_gateway = current_merchant.moneytree_payment_gateway
    redirect_to moneytree.onboarding_stripe_new_path if payment_gateway.blank? || payment_gateway.needs_oauth?

    @order = Order.new
  end

  # GET /marketplace_orders/1/edit
  def edit; end

  # POST /marketplace_orders
  def create
    @order = Order.new(
      merchant_orders: [
        MerchantOrder.new(merchant: current_merchant)
      ]
    )

    transfers = @order.merchant_orders.map do |merchant_order|
      merchant_order.new_payout(
        payment_gateway: merchant_order.merchant.moneytree_payment_gateway,
        amount: 5.0
      )
    end

    transaction = @order.new_payment(
      amount: 10.0,
      transfers: transfers
    )

    if @order.save
      redirect_to edit_marketplace_order_path(@order), notice: 'Marketplace order was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /marketplace_orders/1
  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Marketplace order was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /marketplace_orders/1
  def destroy
    @order.destroy
    redirect_to marketplace_orders_url, notice: 'Marketplace order was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def order_params
    params.fetch(:order, {})
  end
end
