module ApplicationHelper
  def logout_path(return_to)
    return_to = "?return_to=#{return_to}" if return_to
    "#{Rails.configuration.account_ip}/logout#{return_to}"
  end
end
