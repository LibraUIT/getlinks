module ApplicationHelper
  def current_domain
    "#{request.protocol}#{request.host}:#{request.port}"
  end

  def current_namespace
    paths = controller_path.split('/')
    paths.first
  end
end
