# frozen_string_literal: true

class WebhooksController < ApplicationController
  before_action :set_webhook, only: %i[show edit update destroy]
  before_action :check_admin, only: %i[new create edit update destroy]

  # GET /webhooks
  def index
    @webhooks = Webhook.all
  end

  # GET /webhooks/1
  def show; end

  # GET /webhooks/new
  def new
    @webhook = Webhook.new
  end

  # GET /webhooks/1/edit
  def edit; end

  # POST /webhooks
  def create
    @webhook = Webhook.new(webhook_params)
    respond_to do |format|
      if @webhook.save
        format.html { redirect_to webhooks_path, notice: 'Webhook was successfully created.' }
        format.js # This will look for a `create.js.erb` or `update.js.erb` in `views/webhooks/`
      else
        format.html { render :new }
        format.js { render action: 'error' } # Handle errors appropriately
      end
    end
  end

  # PATCH/PUT /webhooks/1
  def update
    @webhook = Webhook.find(params[:id])
    respond_to do |format|
      if @webhook.update(webhook_params)
        format.html { redirect_to webhooks_path, notice: 'Webhook was successfully updated.' }
        format.js # This will look for a `create.js.erb` or `update.js.erb` in `views/webhooks/`
      else
        format.html { render :edit }
        format.js { render action: 'error' } # Handle errors appropriately
      end
    end
  end

  # DELETE /webhooks/1
  def destroy
    @webhook.destroy
    respond_to do |format|
      format.html { redirect_to webhooks_url, notice: 'Webhook was successfully destroyed.' }
      format.js
    end
  end

  private

  def set_webhook
    @webhook = Webhook.find(params[:id])
  end

  def check_admin
    return if current_user.type == 'OperationalUser' && current_user.admin?

    redirect_to root_url, alert: 'You are not authorized to perform this action.'
  end

  def webhook_params
    params.require(:webhook).permit(:customer_id, :url, :secret_token)
  end
end
