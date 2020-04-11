class TokensController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:create]
  # GET /tokens/check
  def check
    email = params[:user_email]
    token = params[:user_token]

    @user = User.find_by(authentication_token: token, email: email)

    if @user.nil?
      render status: 401, json: { message: t('token_authenticatable.invalid_token', default: 'Invalid Token') }
    else
      render json: @user
    end

  end

  # POST /tokens
  def create
    login = params[:email]
    password = params[:password]

    if login.blank? or password.blank?
      render status: 400, json: { message: t('token_authenticatable.request_login_and_password', default: 'The request must contain the user login and password.') }
      return
    end

    @user = User.find_by(email: login.downcase)

    if @user.nil?
      render status: 401, json: { message: t('token_authenticatable.invalid_login_or_password', default: 'Invalid login or password.') }
      return
    end

    @user.save!

    if not @user.valid_password?(password)
      render status: 401, json: { message: t('token_authenticatable.invalid_login_or_password', default: 'Invalid login or password.') }
    else
      render json: @user
    end
  end
end
