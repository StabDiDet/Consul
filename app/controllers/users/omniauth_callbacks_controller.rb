class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    sign_in_with :twitter_login, :twitter
  end

  def facebook
    sign_in_with :facebook_login, :facebook
  end

  def google_oauth2
    sign_in_with :google_login, :google_oauth2
  end

  def wordpress_oauth2
    sign_in_with :wordpress_login, :wordpress_oauth2
  end

  def servicekonto_nrv
    sign_in_with :servicekonto_nrv_login, :servicekonto_nrv
  end

  def after_sign_in_path_for(resource)
    if resource.registering_with_oauth
      finish_signup_path
    else
      super(resource)
    end
  end

  private

    def sign_in_with(feature, provider)
      raise ActionController::RoutingError, "Not Found" unless Setting["feature.#{feature}"]

      auth = request.env["omniauth.auth"]
      identity = Identity.first_or_create_from_oauth(auth)

      if provider == :servicekonto_nrv
        @user = current_user || identity.user || User.first_or_initialize_for_servicekonto_oauth(auth)
      else
        @user = current_user || identity.user || User.first_or_initialize_for_oauth(auth)
      end

      user_should_be_verified = false

      if provider == :servicekonto_nrv
        @user.skip_confirmation!
        @user.skip_confirmation_notification!
      end

      if provider == :servicekonto_nrv
        if current_user.present? && current_user.email != auth.info.email
          current_user.update_column(:email, auth.info.email)
        end

        user_should_be_verified = (
          @user.new_record? || (
            @user.present? &&
            @user.verified_at.blank?
          )
        )
      end

      if save_user
        identity.update!(user: @user)

        if provider == :servicekonto_nrv && user_should_be_verified
          verify_user_with_servicekonto(@user, auth)
        end

        if provider == :servicekonto_nrv && current_user.present?
          flash[:notice] = I18n.t("custom.verification.servicekonto_nrv.flash.success")
          redirect_to(account_path) and return
        end

        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
      else
        session["devise.#{provider}_data"] = auth
        redirect_to new_user_registration_path
      end
    end

    def save_user
      @user.save || @user.save_requiring_finish_signup
    end

    def verify_user_with_servicekonto(user, auth)
      address_data = auth.extra.raw_info["http://www.governikus.de/sk/addresses"]
      street = address_data.street_address

      geozone = Geozone.find_with_plz(address_data.postal_code)
      unique_stamp = user.prepare_unique_stamp

      user.update!(
        street_name: street.gsub(/\s\d+/, ""),
        street_number: street.match(/\d+/)[0],
        city_name: address_data.locality,
        geozone: geozone,
        date_of_birth: DateTime.parse(auth.extra.raw_info.birthdate),
        plz: address_data.postal_code,
        unique_stamp: unique_stamp,
        verified_at: Time.current
      )
    end
end
