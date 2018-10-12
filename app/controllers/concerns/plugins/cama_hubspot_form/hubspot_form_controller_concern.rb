module Plugins::CamaHubspotForm::HubspotFormControllerConcern
  def perform_save_form(form, fields, success, errors)
    if form_new.save
      fields_data = convert_form_values(form, fields)
      message_body = form.the_settings[:railscf_mail][:body].to_s.translate.cama_replace_codes(fields)
      content = render_to_string(partial: plugin_view('hubspot_form/email_content'), layout: false, formats: ['html'], locals: {file_attachments: attachments, fields: fields_data, values: fields, message_body: message_body, form: form})
      cama_send_email(form.the_settings[:railscf_mail][:to], form.the_settings[:railscf_mail][:subject].to_s.translate.cama_replace_codes(fields), {attachments: attachments, content: content, extra_data: {fields: fields_data}})
      success << form.the_message('mail_sent_ok', t('.success_form_val', default: 'Your message has been sent successfully. Thank you very much!'))
      args = {form: form, values: fields}; hooks_run("hubspot_form_after_submit", args)
      if form.the_settings[:railscf_mail][:to_answer].present? && (answer_to = fields[form.the_settings[:railscf_mail][:to_answer].gsub(/(\[|\])/, '').to_sym]).present?
        content = form.the_settings[:railscf_mail][:body_answer].to_s.translate.cama_replace_codes(fields)
        cama_send_email(answer_to, form.the_settings[:railscf_mail][:subject_answer].to_s.translate.cama_replace_codes(fields), {content: content})
      end
    else
      errors << form.the_message('mail_sent_ng', t('.error_form_val', default: 'An error occurred, please try again.'))
    end
  end

  # form validations
  def validate_to_save_form(form, fields, errors)
    validate = true
    form.fields.each do |f|
      cid = f[:cid].to_sym
      label = f[:label].to_sym
      case f[:field_type].to_s
        when 'text', 'website', 'paragraph', 'textarea', 'email', 'radio', 'checkboxes', 'dropdown', 'file'
          if f[:required].to_s.cama_true? && !fields[cid].present?
            errors << "#{label.to_s.translate}: #{form.the_message('invalid_required', t('.error_validation_val', default: 'This value is required'))}"
            validate = false
          end
          if f[:field_type].to_s == 'email'
            unless fields[cid].match(/@/)
              errors << "#{label.to_s.translate}: #{form.the_message('invalid_email', t('.email_invalid_val', default: 'The e-mail address appears invalid'))}"
              validate = false
            end
          end
        when 'captcha'
          error_message = ->{
            errors << "#{label.to_s.translate}: #{form.the_message('captcha_not_match', t('.captch_error_val', default: 'The entered code is incorrect'))}"
            validate = false
          }
            
          if form.recaptcha_enabled?
            form.set_captcha_settings!
            error_message.call unless verify_recaptcha
          else
            error_message.call unless cama_captcha_verified?
          end
      end
    end
    validate
  end

  # form values with labels + values to save
  def convert_form_values(form, fields)
    values = {}
    form.fields.each do |field|
      next unless relevant_field?(field)
      ft = field[:field_type]
      cid = field[:cid].to_sym
      label = values.keys.include?(field[:label]) ? "#{field[:label]} (#{cid})" : field[:label].to_s.translate
      values[label] = []
      if ft == 'file'
        nr_files = fields[cid].size
        values[label] << "#{nr_files} #{"file".pluralize(nr_files)} (attached)" if fields[cid].present?
      elsif ft == 'radio' || ft == 'checkboxes'
        values[label] << fields[cid].map { |f| f.to_s.translate }.join(', ') if fields[cid].present?
      else
        values[label] << fields[cid] if fields[cid].present?
      end
    end
    values
  end

  def relevant_field?(field)
    !%w(captcha submit button).include? field[:field_type]
  end
end