module ApplicationHelper
  def current_domain
    "#{request.protocol}#{request.host}:#{request.port}"
  end

  def current_namespace
    paths = controller_path.split('/')
    paths.first
  end

  def status_name(status)
    status ? 'Actived' : 'Deactived'
  end

  def no_id(index)
    index += 1
  end

  def format_date(date)
    !date.nil? ? date.strftime('%Y-%m-%d') : nil
  end
end
