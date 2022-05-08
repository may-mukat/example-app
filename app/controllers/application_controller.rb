class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :is_admin?
  before_action :login_required

  private
    def current_user
      if session[:user_id]
        current_user ||= User.where(delete_flag: false).find(session[:user_id])
      end
      rescue ActiveRecord::RecordNotFound => e
    end

    def logged_in?
      !!current_user
    end

    def is_admin?
      current_user&.admin_flag?
    end

    def login_required
      redirect_to root_path, alert: 'ログインしてください' unless logged_in?
    end

    def admin_required
      redirect_to root_path, alert: '権限がありません' unless is_admin?
    end
end
