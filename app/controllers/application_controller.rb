class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
    def after_sign_in_path_for(resource)
      if customer_signed_in?
          root_path
      else
        admin_items_top_path
      end
    end

    def after_sign_out_path_for(resource)
      if resource == :admin
        admin_session_path
      else root_path
      end
    end


    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :last_name_kana, :email, :first_name_kana, :post_code, :address, :phone_number ])
    end
end
