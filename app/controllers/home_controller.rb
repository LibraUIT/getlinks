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
    if user_link.host.include? "facebook"
      facebook(link_param[:url])
    elsif user_link.host.include? "instagram"
      instagram(link_param[:url])
    else
      javfilm(params)
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
      uri = URI.parse(url)
      if @supports.map(&:downcase).include? uri.host.downcase
        doc = get_doc(url)
        title = doc.css('title')
        thumb = doc.css('span.general-thumb img[@src]').first
        output = {
          name: title ? title.text : url,
          thumb: thumb ? thumb['src'] : nil,
          url: url
        }
      else
        output = {
          name: url,
          thumb: nil,
          url: url
        }
      end
      output
  end

  def get_doc(path)
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
    Nokogiri::HTML.parse(open(path, {'User-Agent' => user_agent}))
  end

  def parse_video_data(data)
    data = data[:content].split('|')
    data.shift
    video = []
    data.each do |item|
      v = item.split(';')
      video << {
          quality: v[0],
          url: v[1]
        }
    end
    video
  end

  def parse_quality_data(data)
    quality = {
        hd: false,
        hq: false,
        med: false,
        sd: false
    }
    data = data[:content].split('|')
    data.shift
    data.each do |item|
      v = item.split(';')
      if v[0] == "1080p HD"
        quality[:hd] = true
      elsif v[0] == "720 HQ"
        quality[:hq] = true
      elsif v[0] == "480p MED"
        quality[:med] = true
      elsif v[0] == "240p SD"
        quality[:sd] = true
      end
    end
    quality
  end

  def javfilm(params)
    server = Server.find(params[:server][:action].to_i)
    link = Link.find_by(url: link_param[:url])
    quality = {
        hd: false,
        hq: false,
        med: false,
        sd: false
    }
    video = []
    if link && server.id == nil
      @origin = link
      video = parse_video_data(@origin)
      quality = parse_quality_data(@origin)
    else
      if !server.captcha
        uri = URI.parse(server.url)
      end
      @origin = get_from_server(link_param[:url])
      #uri = URI.parse("http://linkaz.net/index.php?action=javpostlink")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data({"link" => link_param[:url]})
      response = http.request(request)
      doc = Nokogiri::HTML(response.body)
      content = ''
      doc.xpath('//a[@href]').each do |link|
        content += "#{link.text.strip};#{link['href']}|"
        video << {
          quality: link.text.strip,
          url: link['href']
        }
        if link.text.strip == "1080p HD"
          quality[:hd] = true
        elsif link.text.strip == "720 HQ"
          quality[:hq] = true
        elsif link.text.strip == "480p MED"
          quality[:med] = true
        elsif link.text.strip == "240p SD"
          quality[:sd] = true
        end
      end
      video.shift
      create = Link.create(@origin.merge(content: content))
      create.save
    end
    @output = {
        video: video,
        quality: quality
    }
  end

  def facebook(url)
    quality = {
        hd: false,
        sd: false
    }
    permission = true
    video = []
    uri = URI.parse('http://www.fbdown.net/down.php')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"URL" => url})
    response = http.request(request)
    doc = Nokogiri::HTML(response.body)
    doc.css('.well').css('center').xpath('//a[@onmouseover]').each do |link|
      video << {
        quality: link.text.strip,
        url: link['href']
      }
      if link.text.strip.upcase.include? "HD"
        quality[:hd] = true
      else
        quality[:sd] = true
      end
      permission = false if link['href'].blank?
    end
    title = doc.css('.well').css('center').css('strong').first.text
    img = doc.css('.well').css('center').css('img.img-thumbnail').first['src']
    @output = {
        video: video,
        quality: quality,
        permission: permission,
        title: title,
        img: img,
        url: url
    }
    render "facebook"
  end

  def instagram(url)
    uri = URI.parse('http://www.dinsta.com/photos/')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"url" => url})
    response = http.request(request)
    doc = Nokogiri::HTML(response.body)
    img = doc.css('#goaway').css('img[@src]')
    @img = doc.css('#goaway').css('img[@src]').first['src']
    render "instagram"
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :content)
  end
end
