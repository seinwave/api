module ApplicationHelper

def show_svg(path)
  File.open("app/assets/images/#{path}", "rb") do |file|
    doc = Nokogiri::XML(file)
    svg = doc.at_css('svg')
    svg['width'] = 80
    svg['height'] = 80
    raw doc.to_xml
  end
end
  
end
