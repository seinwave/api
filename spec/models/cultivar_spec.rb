require 'rails_helper'

RSpec.describe Cultivar, type: :model do
  describe '.search_and_save_image_urls_by_photographer' do
    it 'saves the image URLs for cultivars found by the photographer' do
      cultivar1 = create(:cultivar, name: 'Cultivar1')
      cultivar2 = create(:cultivar, name: 'Cultivar2')

      api_response = {
        'query' => {
          'search' => [
            { 'title' => 'File:Cultivar1 Salicyna.jpg' },
            { 'title' => 'File:Cultivar2 Salicyna.jpg' }
          ]
        }
      }
      allow(URI).to receive(:open).and_return(api_response.to_json)

      Cultivar.search_and_save_image_urls_by_photographer('Salicyna')

      cultivar1.reload
      cultivar2.reload

      expect(cultivar1.image_url).to eq('https://commons.wikimedia.org/wiki/File:Cultivar1_Salicyna.jpg&width=200&height=500')
      expect(cultivar2.image_url).to eq('https://commons.wikimedia.org/wiki/File:Cultivar2_Salicyna.jpg&width=200&height=500')
    end
  end
end
