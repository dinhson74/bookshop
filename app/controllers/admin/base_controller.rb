module Admin
  class BaseController < ApplicationController
    layout 'admin'
    before_action :ensure_admin_user!

    def ensure_admin_user!
      unless current_user&.admin?
        redirect_to root_path, notice: I18n.t('user.errors.messages.you_are_not_an_admin') 
      end
    end
  end
end
