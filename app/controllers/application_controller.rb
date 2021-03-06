class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :servers
  before_action :statistics
  before_action :supports
  before_action :prepare_meta_tags

  def servers
    @servers = Server.all
  end

  def statistics
    @links = Link.all.order(id: :desc).first(10)
  end

  def supports
    @supports = [
      'JAVHD.COM',
      'AV69.tv',
      'HeyMILF.com',
      'AmateurAV.com',
      'PussyAV.com',
      'PovAv.com',
      'HeyOutdoor.com',
      'LingerieAV.com',
      'HairyAV.com',
      'AVStockings.com',
      'AVAnal.com',
      'AVTits.com',
      'SchoolGirlsHD.com',
      'GangAV.com',
      'Ferame.com',
      'Shiofuky.com',
      'Brazzers.com'
    ]
  end

  def prepare_meta_tags(options = {})
    site_name   = 'LINKNHANH.INFO'
    title       = 'Get link mp3,link Instagram, download facebook video, get link Fshare'
    description = 'Get link mp3 lossless, get link Instagram, download facebook video, get link Fshare. Watch hot girl video & photos.'
    image       = options[:image] || 'https://lh3.googleusercontent.com/LvZNB0CzYHAkAYcBHbA2HHcUoBKC9JLToQOTKBC8dW70SAfO8K6Hrg2ZNdFjGvkJ37Dz9JlAy6vPxpk2KyEd9H5jqxUGh7LEaD8TA6V4AmpXmfi9QdJ_dQJNZNTohTXiUg5bYLoGjNn3TqvmBW3vup3HJbSAQCyQ7nm-tG-Z4k51647r4Z119VNtSK_tvvgt4NwqaMADMSRgd2824sn1qAmBGQ3Cn5TOpb1AHVDYE-dvTDfGeTYzCWa9MJrTqaqVhGYt8u4W8WUkDDk7y7KTRphJ3C5jMV-SBmG8oOC9xoUZEGxIlIjm-S6MC5SSxU9VI3D08I3eeVV_GjV2e8BtQgpWqDaeB8JFMRo0-nlKdgOaDoqBYi90JsUhOc07Qy4LHcRBk-I_wYSS7tzZyfkcvDnxr5mflPdzq4qgv81a-2iFSMw-vZ9H6o39ypLxWQpIWD7IcdN_Rl2aYu-9GfMRM6knW4adf7zJ9v0_nVCWp0oU1rAc9rB5RlwGaIYv5d-676nKH3QtRB8o6zPPY9sULoMBQlURuxeb8oucdCF7FH6lUl4egDFMJNp9RjW9vfQyD6nbr43JUKW74AJ05keTlFyWsIc6zjc=w271-h249-no'
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      image:       image,
      description: description,
      keywords:    'get link, download facebook video, download video instagram, get link fshare, get link mp3 lossless, download video youtube, girl xinh, hot girl, photos, xem anh girl xinh',
      twitter: {
        site_name: site_name,
        site: '@linknhanh.info',
        card: 'summary',
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end
end
