require 'nokogiri'
require 'open-uri'

class MetroSp

  attr_reader :escolha_do_usuario, :nome_linha, :status_linha, :string_para_verificacao, :hash_das_informacoes, :conteudo_linhas

  def initialize
    url = "http://www.metro.sp.gov.br/Sistemas/direto-do-metro-via4/MetroStatusLinha/mobile/smartPhone/diretoDoMetro.aspx"
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    @conteudo_linhas = doc.css('div.status-linhas li')
  end

  def web
    get_name
    get_status
    hash_zipado
    escolher_estacao
  end

  def get_name
    linhas = conteudo_linhas.search('p strong')
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
    pedir_escolha
  end

  def pedir_escolha
    @escolha_do_usuario = gets.chomp.capitalize.to_s
    conferir_escolha
  end

  def conferir_escolha
    if escolha_do_usuario == "Listar"
      puts hash_das_informacoes
    else
      resposta = find_line_status(@escolha_do_usuario)
      if resposta.any?
        puts resposta.first.fetch(:status, "")
      else
        puts "Informação não encontrada"
        puts "Tente novamente: "
        pedir_escolha
      end
    end
  end

  private

  def find_line_status(escolha_do_usuario)
    hash_das_informacoes.select{|item| item[:name] == escolha_do_usuario}
  end
end
