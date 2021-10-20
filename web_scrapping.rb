require 'nokogiri'
require 'open-uri'

class MetroSp

  attr_reader :linhas, :status, :nome_linha, :status_linha, :hash_das_informacoes, :url, :html, :doc

  def initialize
    @url = "http://www.metro.sp.gov.br/Sistemas/direto-do-metro-via4/MetroStatusLinha/mobile/smartPhone/diretoDoMetro.aspx"
    @html = URI.open(url)
    @doc = Nokogiri::HTML(html)
  end

  def web
    get_name
    get_status
    hash_zipado
  end

  def get_name
    #@linhas = doc.css('div.status-linhas li')
    #@nome_linha = @linhas.search('p strong').map do |linha|
    #  linha.content
    #end
    @linhas = doc.xpath("//li//p//strong")
    @nome_linha = linhas.map do |linha|
      linha.content
    end
    pp nome_linha
  end

  def get_status
    #status = doc.css('div.status-linhas li')
    #status_linha = status.search('p a').map do |operacao|
    #  operacao.content
    #end
    @status = doc.xpath("//li//div//p//a")
    @status_linha = status.map do |operacao|
      operacao.content
    end
    pp status_linha
  end

  def hash_zipado
    @hash_das_informacoes = nome_linha.zip(status_linha).to_h
    pp hash_das_informacoes
  end
end

MetroSp.new.web