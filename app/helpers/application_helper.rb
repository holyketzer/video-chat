module ApplicationHelper
  FLASH_TYPES_MAPPING = {
    success: 'alert-success',
    error: 'alert-danger',
    alert: 'alert-warning',
    notice: 'alert-info',
  }.freeze

  def bootstrap_class_for(flash_type)
    FLASH_TYPES_MAPPING.fetch(flash_type.to_sym, flash_type)
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(
        content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do
          concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
          concat message
        end
      )
    end
    nil
  end
end
