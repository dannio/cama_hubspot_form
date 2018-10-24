class Plugins::CamaHubspotForm::FrontController < CamaleonCms::Apps::PluginsFrontController
  include Plugins::CamaHubspotForm::MainHelper
  
  # here add your custom functions
  def save_form
    flash[:hubspot_form] = {}
    form = Hubspot::Form.find(params['id'])
    redirect = params['custom_redirect']
    hs_context = { hutk: cookies[:hubspotutk], ipAddress: request.remote_ip, pageUrl: "#{request.referrer}", pageName: "#{request.referrer}"  }.to_json
    hubspot_params = params.except("controller", "action", "slug", "id", "authenticity_token", "utf8", "custom_redirect").to_unsafe_h
    hubspot_params[:hs_context] = hs_context
    form.submit(hubspot_params)
    if redirect
      redirect_to redirect
    else
      redirect_to form.properties['redirect']
    end
  end
end
