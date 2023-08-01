require 'rails_helper'

RSpec.describe CultivarImageUpdater do
  describe '.update_images_by_photographer' do
    let!(:cultivar1) { create(:cultivar, name: 'Rose1') }
    let!(:cultivar2) { create(:cultivar, name: 'Rose2') }

    it 'updates image URLs for cultivars by photographer Salicyna' do
      # Stub the API response for each cultivar
      allow(URI).to receive(:open).with("https://commons.wikimedia.org/w/api.php?action=query&format=json&list=search&srsearch=#{cultivar1.name}+Salicyna&srlimit=1")
        .and_return(File.read('spec/fixtures/wikimedia_api_response_cultivar1.json'))
      allow(URI).to receive(:open).with("https://commons.wikimedia.org/w/api.php?action=query&format=json&list=search&srsearch=#{cultivar2.name}+Salicyna&srlimit=1")
        .and_return(File.read('spec/fixtures/wikimedia_api_response_cultivar2.json'))

      CultivarImageUpdater.update_images_by_photographer('Salicyna')

      cultivar1.reload
      cultivar2.reload
      expect(cultivar1.image_url).to eq('https://commons.wikimedia.org/wiki/File:Rosa_Jude_the_Obscure_2019-06-04_6111.jpg&width=200&height=500')
      expect(cultivar2.image_url).to eq('https://commons.wikimedia.org/wiki/File:Rosa_Jude_the_Obscure_2019-06-04_6110.jpg&width=200&height=500')
    end
  end
end
