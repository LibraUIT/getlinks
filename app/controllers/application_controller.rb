class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :servers
  before_filter :statistics
  before_filter :supports

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
end
