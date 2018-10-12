class Plugins::CamaHubspotForm::AdminFormsController < CamaleonCms::Apps::PluginsAdminController
  include Plugins::CamaHubspotForm::MainHelper
  include Plugins::CamaHubspotForm::HubspotFormControllerConcern
  before_action :set_form, only: ['show','edit','update','destroy']
  add_breadcrumb I18n.t("plugins.cama_hubspot_form.title", default: 'Hubspot Form'), :admin_plugins_cama_hubspot_form_admin_forms_path

  def index
    @forms = Hubspot::Form.all
  end


  def responses
    add_breadcrumb I18n.t("plugins.cama_hubspot_form.list_responses", default: 'Hubspot form records')
    @form = current_site.hubspot_forms.where({id: params[:admin_form_id]}).first
    values = JSON.parse(@form.value).to_sym
    @op_fields = values[:fields].select{ |field| relevant_field? field }
    @forms = current_site.hubspot_forms.where({parent_id: @form.id})
    @forms = @forms.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
  end

  def del_response
    response = current_site.hubspot_forms.find_by_id(params[:response_id])
    if response.present? && response.destroy
      flash[:notice] = "#{t('.actions.msg_deleted', default: 'The response has been deleted')}"
    end
    redirect_to action: :responses
  end

  def manual

  end

  def item_field
    render partial: 'item_field', locals:{ field_type: params[:kind], cid: params[:cid] }
  end

  # here add your custom functions
  private
  def set_form
    begin
      @form = current_site.hubspot_forms.find_by_id(params[:id])
    rescue
      flash[:error] = "Error form class"
      redirect_to cama_admin_path
    end
  end
end
