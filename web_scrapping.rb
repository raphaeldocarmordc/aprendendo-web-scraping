require 'nokogiri'
require 'open-uri'
require 'byebug'

class MetroSP
  def initialize
    url = "http://www.metro.sp.gov.br/Sistemas/direto-do-metro-via4/MetroStatusLinha/mobile/smartPhone/diretoDoMetro.aspx"
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    titulo = doc#parse

    linhas = doc.css('div.status-linhas li')

    nome_linha = linhas.search('p strong').map do |linha|
      linha.content
    end
    pp nome_linha

    
   # linhas.xpath('//div//li').each do |infos|
    #  nome_linha = linhas.at('.align-left').text
    #end
   # puts nome_linha

  end
end

MetroSP.new