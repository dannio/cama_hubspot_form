class Plugins::CamaHubspotForm::AdminFormsController < CamaleonCms::Apps::PluginsAdminController
  include Plugins::CamaHubspotForm::MainHelper
  add_breadcrumb I18n.t("plugins.cama_hubspot_form.title", default: 'Hubspot Form'), :admin_plugins_cama_hubspot_form_admin_forms_path

  def index
    @forms = Hubspot::Form.all
  end
end
