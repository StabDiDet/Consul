module FormularFieldsActions
  extend ActiveSupport::Concern

  included do
    respond_to :js

    before_action :set_projekt_phase, :set_formular
    before_action :set_formular_field, only: %i[update destroy]
  end

  def new
    @formular_field = @formular.formular_fields.new
    authorize!(:new, @formular_field) unless current_user.administrator?

    render "custom/admin/formular_fields/new"
  end

  def create
    @formular_field = FormularField.new(formular_field_params)
    @formular_field.formular = @formular
    authorize!(:create, @formular_field) unless current_user.administrator?

    if @formular_field.save
      render "custom/admin/formular_fields/create"
    else
      render :new
    end
  end

  def update
    authorize!(:update, @formular_field) unless current_user.administrator?

    if @formular_field.update(formular_field_params)
      render "custom/admin/formular_fields/update"
    else
      render :edit
    end
  end

  def destroy
    authorize!(:destroy, @formular_field) unless current_user.administrator?

    @formular_field.destroy!
    render "custom/admin/formular_fields/destroy"
  end

  private

    def set_projekt_phase
      @projekt_phase = ProjektPhase.find(params[:projekt_phase_id])
    end

    def set_formular
      @formular = Formular.find(params[:formular_id])
    end

    def set_formular_field
      @formular_field = FormularField.find(params[:id])
    end

    def formular_field_params
      params.require(:formular_field).permit(:name, :description, :key, :required, :kind, options: {})
    end
end
