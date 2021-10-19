require 'nokogiri'
require 'open-uri'
require 'byebug'

class MetroSP
  def initialize
    url = 'http://www.metro.sp.gov.br/Sistemas/direto-do-metro-via4/MetroStatusLinha/mobile/smartPhone/diretoDoMetro.aspx'
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    titulo = doc.parse.title
    #Nokogiri::HTML.parse(open('')).title
  end
end