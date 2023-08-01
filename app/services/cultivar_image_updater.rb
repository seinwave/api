require 'open-uri'
require 'json'
require 'httparty'

# cultivars = Cultivar.first(40)

# def filter_out_invalid_links(item)
#   link = item.link
#   return false if check_is_shopify(link)
#   return false if check_is_webp(link)
#   return false if check_is_not_https(link)
#   return true
# end

# def check_is_webp(link)
#   return link.split('.')[-1] == 'webp'
# end

# # shopify links don't work (gatekeeping)
# def check_is_shopify(link)
#     uri = URI(link)
#     puts uri
#     host = uri.host
#     return host == 'cdn.shopify.com' || host == 'shopify.com'
# end

# def check_is_not_https(link)
#   return link.split(':')[0] != 'https'
# end

# def hsl_to_string(hsl)
#   return "" if hsl.nil?
#   return "hsl(#{hsl.join(",")})"
# end

# cultivars.each do |cultivar|

#     puts 'CULTIVAR, ID:', cultivar.name, cultivar.id
#     #skip if there is already a CultivarColor entry for this cultivar
#     # next if !CultivarColor.where(cultivar: cultivar).empty?

#     results = GoogleCustomSearchApi.search("rose #{cultivar.name}", {searchType: "image"})
#     if results["items"].nil? || results["items"].empty?
#       puts "NO RESULTS"
#       next
#     end

#     safe_link = results["items"].detect{|item| filter_out_invalid_links(item) }.link

#     next if safe_link.nil?
#     next if safe_link == ""

#     begin
#       colors = RailsDominantColors.url(safe_link, 5)


#     rescue => exception
#       puts "EXCEPTION:", exception
#       next
#     end

#     colors = colors.to_hsl.delete_if { |color| color[0] > 60 && color[0] < 180 }



#     primary_color = hsl_to_string(colors[0])
#     accent_color = hsl_to_string(colors[1])

#     puts primary_color, accent_color

#     # CultivarColor.create(cultivar: cultivar, primary_color: primary_color, accent_color: accent_color)


# end


def fetch_image_data(query)
  url = "https://commons.wikimedia.org/w/api.php?action=query&format=json&generator=search&gsrsearch=#{query}&gsrlimit=1&prop=imageinfo&iiprop=url|extmetadata"
  response = HTTParty.get(url)
  data = JSON.parse(response.body)
  return nil unless data['query'] && data['query']['pages']

  page_id = data['query']['pages'].keys.first
  image_data = data['query']['pages'][page_id]['imageinfo'][0]
  {
    image_url: image_data['url'],
    license: image_data['extmetadata']['LicenseShortName']['value'],
    attribution: image_data['extmetadata']['Attribution']['value']
  }
end


class CultivarImageUpdater
  def self.update_images_by_photographer(photographer_name)
    Cultivar.find_each do |cultivar|
        puts cultivar.name
        query = "#{cultivar.name} #{photographer_name}"
        image_data = fetch_image_data(query)
        next unless image_data
        puts image_data
    end
  end
end
