# frozen_string_literal: true

module OperationalPortal
  class UsersController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      query_instance = User.with_customer.sort_desc

      if params[:search].present? && params[:search_by].present?
        search_query = ''
        search_query += 'first_name ILIKE :search OR last_name ILIKE :search' if params[:search_by].include?('name')
        search_query += "#{or_q(search_query)} email ILIKE :search" if params[:search_by].include?('email')
        search_query += "#{or_q(search_query)} role ILIKE :search" if params[:search_by].include?('role')
        if params[:search_by].include?('customer_name')
          search_query += "#{or_q(search_query)} customers.name ILIKE :search"
        end

        query_instance = query_instance.where(search_query, search: "%#{params[:search]}%") if search_query.present?
      end

      query_instance = query_instance.accessible_by(current_ability)

      @pagy, @users = pagy(query_instance)
    end

    def show; end

    def new; end

    def edit; end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to operational_portal_users_path, notice: 'User was successfully created.'
      else
        render :new
      end
    end

    def update
      if @user.update(user_params)
        redirect_to operational_portal_users_path, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @user.destroy!
      redirect_to operational_portal_users_path, notice: 'User was successfully deleted.'
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :phone, :role, :password, :password_confirmation,
                                   :customer_id)
    end
  end
end
