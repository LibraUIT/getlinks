class GetLinkService
  def get_from_server(url, supports)
    uri = URI.parse(url)
    if supports.map(&:downcase).include? uri.host.downcase
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

  def javhd(url, supports, _origin)
    uri = URI.parse(url)
    doc = get_doc(url)
    if supports.map(&:downcase).include? uri.host.downcase
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
    origin = output
    quality = {
      hd: false,
      hq: false,
      med: false,
      sd: false
    }
    jav_name = nil
    unless output[:thumb].nil?
      jav_link_name = output[:thumb].split('/')
      jav_name = jav_link_name[4]
      jav_name = jav_name.gsub('-p', '')
    end
    video = []
    doc.css('.downloads').css('ul').each do |download|
      content = download.text
      if content.include? 'HD'
        quality[:hd] = true
        q = 'hq'
        video << {
          quality: 'HQ Quality',
          url: auto_url(jav_name, q)
        }
      end
      if content.include? 'Normal'
        quality[:hq] = true
        q = 'sh'
        video << {
          quality: 'Normal Quality',
          url: auto_url(jav_name, q)
        }
      end
      if content.include? 'Low'
        quality[:med] = true
        q = 'med'
        video << {
          quality: 'Low Quality',
          url: auto_url(jav_name, q)
        }
      end
      next unless content.include? 'iPhone'
      quality[:sd] = true
      q = 'low'
      video << {
        quality: 'iPhone Version',
        url: auto_url(jav_name, q)
      }
    end
    output[:video] = video
    output[:quality] = quality
    output
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
    request.set_form_data('URL' => url)
    response = http.request(request)
    doc = Nokogiri::HTML(response.body)
    doc.css('.well').css('center').xpath('//a[@onmouseover]').each do |link|
      video << {
        quality: link.text.strip,
        url: link['href']
      }
      if link.text.strip.upcase.include? 'HD'
        quality[:hd] = true
      else
        quality[:sd] = true
      end
      permission = false if link['href'].blank?
    end
    title = doc.css('.well').css('center').css('strong').first.text
    img = doc.css('.well').css('center').css('img.img-thumbnail').first['src']
    output = {
      video: video,
      quality: quality,
      permission: permission,
      title: title,
      img: img,
      url: url
    }
    output
  end

  def instagram(url)
    uri = URI.parse('http://www.dinsta.com/photos/')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data('url' => url)
    response = http.request(request)
    doc = Nokogiri::HTML(response.body)
    img = doc.css('#goaway').css('img[@src]')
    img = doc.css('#goaway').css('img[@src]').first['src']
    img
  end

  private

  def get_doc(path)
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'
    Nokogiri::HTML.parse(open(path, 'User-Agent' => user_agent))
  end

  def auto_url(jav_name, q)
    "http://cs341.wpc.alphacdn.net/802D70B/OriginJHVD/contents/#{jav_name}/videos/#{jav_name}_#{q}.mp4"
  end

end
