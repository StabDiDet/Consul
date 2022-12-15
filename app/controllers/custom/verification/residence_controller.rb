require_dependency Rails.root.join("app", "controllers", "verification", "residence_controller").to_s

class Verification::ResidenceController < ApplicationController
  def new
    current_user_attributes = current_user.attributes.transform_keys(&:to_sym).slice(*allowed_params)
    @residence = Verification::Residence.new(current_user_attributes)
  end

  def create
    @residence = Verification::Residence.new(residence_params.merge(user: current_user))

    if @residence.save
      redirect_to account_path, notice: t("custom.verification.residence.create.flash.success_manual")
    else
      render :new
    end
  end

  private

    def allowed_params
      [
        :document_number, :document_type, :date_of_birth, :postal_code, :terms_of_service,
        :first_name, :last_name, :street_name, :street_number,
        :plz, :city_name, :gender, :document_type, :document_last_digits
      ]
    end
end
