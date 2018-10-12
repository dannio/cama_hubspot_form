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
      field['label']          = field['label'].to_s.translate
      hidden                  = field['hidden'] ? 'display: none': ''
      f_name                  = field['name']
      dependent_field_filters = field['dependentFieldFilters']
      validation_notice       = "请完成表单"
      temp                    = ""
      label                   = "<label>#{field['label']}"
      if field['required'] 
        label                += "*"
      end
      label                  += "</label>"

      html += label

      case field['fieldType'].to_s
        when 'textarea'
          temp = "<textarea style='#{hidden}' class='marginB5' name='#{field['name']}' type='#{field['fieldType']}'"
          if field['required'] 
            temp += "required='#{field['required']}' oninvalid='this.setCustomValidity(\"#{validation_notice}\")' oninput='setCustomValidity('') "
          end
          temp += "></textarea>"
        when 'radio'
          temp =  cama_hubspot_form_select_multiple_bootstrap(field, "radio")
        when 'checkboxes'
          temp =  cama_hubspot_form_select_multiple_bootstrap(field, "checkbox")
        when 'text'
          temp = "<input style='#{hidden}' class='marginB5' name='#{field['name']}' type='#{field['fieldType']}'"
          if field['required'] 
            temp += "required='#{field['required']}' oninvalid='this.setCustomValidity(\"#{validation_notice}\")' oninput='setCustomValidity('') "
          end
          temp += ">"
        when 'select'
          temp = cama_hubspot_form_select_multiple_bootstrap(field, "select")
        else
      end
      html += temp

      dependent_field_filters.each do |dependent|
        temp2 = ""
        str_filter = dependent['filters'].map {|x| x['operator']}.join('###')
        str_values = dependent['filters'].map {|x| x['strValues']}.join('###')
        dependent_form_field = dependent['dependentFormField']
        hidden  = dependent_form_field['hidden'] ? 'display: none': ''
        label                   = "<label>#{dependent_form_field['label']}"
        if dependent_form_field['required'] 
          label                += "*"
        end
        label                  += "</label>"
        if dependent_field_filters
          dependent_class = "has_dependents"
        end
        
        html += "<div class='dependant_fields #{field['name']}' data-condition='#{str_filter}' data-strValue='#{str_values}'>"
        html += label
        case dependent_form_field['fieldType'].to_s
          when 'textarea'
            temp2 = "<textarea style='#{hidden}' class='marginB5' name='#{dependent_form_field['name']}' type='#{dependent_form_field['fieldType']}'"
            if field['required'] 
              temp2 += "required='#{dependent_form_field['required']}' oninvalid='this.setCustomValidity(\"#{validation_notice}\")' oninput='setCustomValidity('') "
            end
            temp2 += "></textarea>"
          when 'radio'
            temp2=  cama_hubspot_form_select_multiple_bootstrap(dependent_form_field, "radio")
          when 'checkbox'
            temp2=  cama_hubspot_form_select_multiple_bootstrap(dependent_form_field, "checkbox")
          when 'text'
            temp2 = "<input style='#{hidden}' class='marginB5' name='#{dependent_form_field['name']}' type='#{dependent_form_field['fieldType']}'"
            if field['required'] 
              temp2 += "required='#{dependent_form_field['required']}' oninvalid='this.setCustomValidity(\"#{validation_notice}\")' oninput='setCustomValidity('') "
            end
            temp2 += ">"
          when 'select'
            temp2 = cama_hubspot_form_select_multiple_bootstrap(dependent_form_field, "select")
          else
        end
        html += temp2
        html += "</div>"
      end
    end
    html += cama_hubspot_form_legal_consent_field(form)
  end

  def cama_hubspot_form_select_multiple_bootstrap(field, type)
    options = field["options"]
    other_input = ""
    f_name = field["name"]
    html = ""
    dependent_class = ""
    dependent_field_filters = field['dependentFieldFilters']
    type = field['fieldType']

    if dependent_field_filters
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
      html = "#{label} #{consent_field_data["privacyPolicyText"]}"
    end
    return html
  end
end
