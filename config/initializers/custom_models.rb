Rails.application.config.to_prepare do
  CamaleonCms::Site.class_eval do
    has_many :hubspot_forms, :class_name => "Plugins::CamaHubspotForm::CamaHubspotForm", foreign_key: :site_id, dependent: :destroy
  end
end