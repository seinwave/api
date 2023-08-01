require 'open-uri'
require 'json'
require 'httparty'


def get_public_domain_image_url(cultivar)
    name = cultivar.name
    google_url = "https://www.googleapis.com/customsearch/v1?"

    parameters = {
        key: ENV['GOOGLE_API_KEY'],
        cx: ENV['GOOGLE_CX'],
        q: "#{name} rose",
        searchType: "image",
        imgSize: "medium",
        imgType: "photo",
        rights: "cc_publicdomain",
     }

    response = HTTParty.get(google_url, query: parameters)

    puts response

    if response.code == 200
        data = JSON.parse(response.body)

        image_url = data["items"][0]["link"]

        return image_url
    else 
        puts 'ERROR: unable to fetch'
        return nil
    end
end


class CultivarImageUpdater
  def self.update_images_by_photographer(photographer_name)
    Cultivar.find_each do |cultivar|
        puts 'FETCHING IMAGE_URL FOR', cultivar.name
        image_url = get_public_domain_image_url(cultivar)
        next unless image_url
        puts 'IMAGE URL SUCCESSFULLY FETCHED:', image_url
    end
  end
end

