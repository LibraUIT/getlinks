module ApplicationHelper
  def current_domain
    "#{request.protocol}#{request.host}:#{request.port}"
  end
end
