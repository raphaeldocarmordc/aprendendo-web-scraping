require 'nokogiri'
require 'open-uri'

class MetroSp

  attr_reader :linhas, :i, :escolha_do_usuario, :nome_linha, :status_linha, :string_para_verificacao, :hash_das_informacoes, :url, :html, :doc, :conteudo_linhas

  def initialize
    @url = "http://www.metro.sp.gov.br/Sistemas/direto-do-metro-via4/MetroStatusLinha/mobile/smartPhone/diretoDoMetro.aspx"
    @html = URI.open(url)
    @doc = Nokogiri::HTML(html)
    @conteudo_linhas = doc.css('div.status-linhas li')
  end

  def web
    get_name
    get_status
    hash_zipado
    escolher_estacao
    conferir_escolha
  end

  def get_name
    #@nome_linha = @linhas.search('p strong').map do |linha|
    #  linha.content
    #end
    @linhas = doc.xpath("//li//p//strong")
    @nome_linha = linhas.map do |linha|
      linha.content
    end
  end

  def get_status
    status_linhas = conteudo_linhas.search('li a')
    status_linhas.map do |operacao|
      operacao.content.strip.tr("\t/\r/\n", "") #método strip pega todos os caractéres antes da vírgula como string e substitui pelo que esta depois da vírgula como string
    end
  end

  def hash_zipado
    @hash_das_informacoes = nome_linha.zip(get_status).to_h.map{|key, value| {name: key, status: value}}
  end

  def escolher_estacao
    puts "\nDentre as #{nome_linha.size} linhas do Metrô de SP,"
    puts "se tem as opções: #{nome_linha}."
    puts "Você deseja consultar o status de qual delas?"
    puts "Digite o nome ou o número da linha escolhida, por gentileza: "
    escolha_do_usuario = gets.chomp.downcase.to_s
    @string_para_verificacao = escolha_do_usuario.strip.tr(" ", "")
  end

  def conferir_escolha
    case string_para_verificacao
    when "linha1", "1"
      puts hash_das_informacoes[0].values
    when "linha2", "2"
      puts hash_das_informacoes[1].values
    when "linha3", "3"
      puts hash_das_informacoes[2].values
    when "linha15", "15"
      puts hash_das_informacoes[3].values
    when "linha4", "4"
      puts hash_das_informacoes[4].values
    else
      puts "\nInformação não encontrada"
    end

  #  hash_das_informacoes.each do |hash|
  #    hash.select{|k, v| v == escolha_do_usuario}
  #  end

  end
end

MetroSp.new.web