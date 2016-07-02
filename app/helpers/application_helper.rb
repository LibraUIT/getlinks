module ApplicationHelper
  def current_domain
    if controller_name != 'blogs'
      "#{request.protocol}#{request.host}:#{request.port}"
    else
      "#{request.protocol}#{request.host}:#{request.port}#{ request.fullpath}"
    end
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
