require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'fileutils'
class HomeController < ApplicationController

  def index
    @link = Link.new
  end

  def getlink
    @link = Link.new
    user_link = URI.parse(link_param[:url])
    if user_link.host.include? 'facebook'
      facebook(link_param[:url])
    elsif user_link.host.include? 'instagram'
      instagram(link_param[:url])
    elsif user_link.host.include? 'javhd'
      javhd(link_param[:url])
    end
  end

  def preview
    video = params[:video]
    cdn_creation_time = params[:cdn_creation_time]
    cdn_ttl = params[:cdn_ttl]
    cdn_bw = params[:cdn_bw]
    cdn_cv_memberid = params[:cdn_cv_memberid]
    @video = "#{video}&cdn_creation_time=#{cdn_creation_time}&cdn_ttl=#{cdn_ttl}&cdn_bw=#{cdn_bw}&cdn_cv_memberid=#{cdn_cv_memberid}"
  end

  def about
    @link = Link.new
  end

  def terms; end

  def website; end

  def contact
    @contact = Contact.new
  end

  def use; end

  def create_contact
    @contact = Contact.create(contact_params)
    respond_to do |format|
      if @contact.save
        format.html { redirect_to contact_path, notice: 'Your message was successfully send.' }
        format.json { render :new, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def link_param
    params.require(:link).permit(:url)
  end

  def get_from_server(url)
    GetLinkService.new.get_from_server(url, supports)
  end

  def facebook(url)
    @output = GetLinkService.new.facebook(url)
    render 'facebook'
  end

  def instagram(url)
    @img = GetLinkService.new.instagram(url)
    render 'instagram'
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :content)
  end

  def javhd(url)
    @output = GetLinkService.new.javhd(url, @supports, @origin)
    @origin = @output
  end

  def prepare_link
    @link = Link.new
  end
end
