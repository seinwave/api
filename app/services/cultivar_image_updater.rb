require 'open-uri'
require 'json'

class CultivarImageUpdater
  def self.update_images_by_photographer(photographer_name)
    Cultivar.find_each do |cultivar|
      url = "https://commons.wikimedia.org/w/api.php?action=query&format=json&list=search&srsearch=#{cultivar.name}+#{photographer_name}&srlimit=1"
      response = URI.open(url).read
      data = JSON.parse(response)
      image_url = data.dig('query', 'search', 0, 'title')

      if image_url.present?
        image_url.sub!('File:', 'https://commons.wikimedia.org/wiki/File:')
        cultivar.update(image_url: "#{image_url}&width=200&height=500")
      end
    end
  end
end
