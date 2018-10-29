module Plugins::CamaHubspotForm::MainHelper
  include Recaptcha::ClientHelper
  def self.included(klass)
    klass.helper_method [:cama_hubspot_form_element_bootstrap_object, :cama_hubspot_form_shortcode] rescue "" # here your methods accessible from views
  end

  # here all actions on plugin destroying
  # plugin: plugin model
  def hubspot_form_on_destroy(plugin)
  end

  # here all actions on going to active
  # you can run sql commands like this:
  # results = ActiveRecord::Base.connection.execute(query);
  # plugin: plugin model
  def hubspot_form_on_active(plugin)

  end

  # here all actions on going to inactive
  # plugin: plugin model
  def hubspot_form_on_inactive(plugin)

  end

  def hubspot_form_admin_before_load
    admin_menu_append_menu_item("settings", {icon: "envelope-o", title: t('plugins.cama_hubspot_form.title', default: 'Hubspot Form'), url: admin_plugins_cama_hubspot_form_admin_forms_path, datas: "data-intro='This plugin permit you to view you Hubspot Forms and paste your short_code in any content.' data-position='right'"})
  end

  def hubspot_form_app_before_load
    shortcode_add('cama_hubspot_forms', plugin_view("hubspot_forms_shortcode"), "This is a shortocode for Hubspot Form to permit you to put your Hubspot Form in any content. Sample: [cama_hubspot_forms guid=guid-for-form]")
  end

  def hubspot_form_front_before_load

  end

  # ============== HTML ==================
  # This returns the format of the plugin shortcode.
  def cama_hubspot_form_shortcode(guid)
    "[cama_hubspot_forms guid=#{guid}]"
  end

  # form contact with css bootstrap
  def cama_hubspot_form_element_bootstrap_object(form)
    html = ""
    form.fields.each do |field|
      dependent_field_filters = field['dependentFieldFilters']
      html += cama_hubspot_form_element_bootstrap_object_field(field)
      dependent_field_filters.each do |dependent|
        str_filter = dependent['filters'].map {|x| x['operator']}.join('###')
        str_values = dependent['filters'].map {|x| x['strValues']}.join('###')
        str_value  = dependent['filters'].map {|x| x['strValue']}.first
        dependent_form_field = dependent['dependentFormField']
        html += "<div class='dependant_fields #{field['name']}' data-required='#{dependent['dependentFormField']['required']}' data-condition='#{str_filter}' data-strValues='#{str_values}' data-strValue='#{str_value}'>"
        html += cama_hubspot_form_element_bootstrap_object_field(dependent, false)
        html += "</div>"
      end
    end
    html += cama_hubspot_form_legal_consent_field(form)
  end

  def cama_hubspot_form_element_bootstrap_object_field(field, parent = true)
    if !parent
      field = field['dependentFormField']
    end
    hidden                  = field['hidden'] ? 'display: none': ''
    f_name                  = field['name']
    validation_notice       = "请完成表单"
    temp                    = ""
    dependent_field_filters = field['dependentFieldFilters']
    if dependent_field_filters.present?
      dependent_class = "has_dependents"
    end
    case field['fieldType'].to_s
      when 'textarea'
        temp = cama_hubspot_form_field_label(field)
        temp += "<textarea style='#{hidden}' class='#{dependent_class}' id='#{field['name']}' name='#{field['name']}' type='#{field['fieldType']}'"
        if field['required'] && parent
          temp += "required='#{field['required']}' oninvalid='this.setCustomValidity(\"#{validation_notice}\")' oninput='setCustomValidity('') "
        end
        temp += "></textarea>"
      when 'radio'
        temp = cama_hubspot_form_field_label(field)
        temp += cama_hubspot_form_select_multiple_bootstrap(field, "radio")
      when 'checkbox'
        temp = cama_hubspot_form_field_label(field)
        temp += cama_hubspot_form_select_multiple_bootstrap(field, "checkbox")
      when 'booleancheckbox'
        temp = "<label>"
        temp += "<input style='#{hidden}' class='#{dependent_class}' id='#{field['name']}' name='#{field['name']}' type='checkbox' value='Yes'"
        if field['required'] && parent
          temp += "required='#{field['required']}' oninvalid='this.setCustomValidity(\"#{validation_notice}\")' oninput='setCustomValidity('')"
        end
        temp += ">"
        temp += " #{field['label']}"
        if field['required'] 
          temp += "*"
        end
        temp += "</label>"
      when 'text'
        temp = cama_hubspot_form_field_label(field)
        temp += "<input style='#{hidden}' class='#{dependent_class}' id='#{field['name']}' name='#{field['name']}' type='#{field['fieldType']}'"
        if field['required'] && parent
          temp += "required='#{field['required']}' oninvalid='this.setCustomValidity(\"#{validation_notice}\")' oninput='setCustomValidity('') "
        end
        temp += ">"
      when 'select'
        temp = cama_hubspot_form_field_label(field)
        temp += cama_hubspot_form_select_multiple_bootstrap(field, "select")
      else
    end
    return temp
  end

  def cama_hubspot_form_select_multiple_bootstrap(field, type)
    options = field["options"]
    f_name = field["name"]
    dependent_field_filters = field['dependentFieldFilters']
    dependent_class = ""
    type = field['fieldType']
    html = ""
    if dependent_field_filters.present?
      dependent_class = "has_dependents"
    end
    if type == "select"
      html = "<select name='#{f_name}' class='#{dependent_class}' id='#{field['name']}'>"
      html += "<option value=''>#{field['unselectedLabel']}</option>"
    end
    options.each do |op|
      label = op['label'].translate
      if type == "radio" || type == "checkbox"
        html += "<div class='#{type}'  class='#{dependent_class}'>
                    <label for='#{f_name}'>
                      <input type='#{type}' name='#{f_name}[]' value='#{op['value']}'>
                      #{op['label']}
                    </label>
                  </div>"
      else
        html += "<option value='#{op['value']}'>#{op['label']}</option>"
      end
    end
    if type == "select"
      html += " </select>"
    end
    html
  end

  def cama_hubspot_form_legal_consent_field(form)
    label = ""
    html = ""
    if form.properties['metaData'].last['name'] == 'legalConsentOptions' 
      consent_field_data = JSON.parse(form.properties['metaData'].last['value'])
      label_text = consent_field_data['communicationConsentCheckboxes'].first['label']
      label = "<label><input type='checkbox' name='hs_legal_basis' value='Legitimate interest – prospect/lead'> #{label_text}</label>"
      html = "<div class='cama-hubspot-form-consent-wrapper'>#{label} <p>#{consent_field_data["privacyPolicyText"]}</p></div>"
    end
    return html
  end

  def cama_hubspot_form_field_label(field)
    label = "<label>#{field['label']}"
    if field['required'] 
      label += "*"
    end
    label += "</label>"
    label
  end
end
