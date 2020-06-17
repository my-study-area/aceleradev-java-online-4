require 'byebug'
require 'rest-client'
require 'json'
require 'rickshaw'
require 'date'
require_relative 'token'
require_relative 'lib/cesar_cipher'

@option = "1"
@token = ''
@json = {}

def show_header
    puts '+' * 60
    puts 'Desafio Java online'.center(60, '-')
    puts 'Criptografia de Júlio César'.center(60,' ')
    puts '=' * 60
end

def show_options
    puts 'Selecione uma opção:'
    puts '1 - Menu'
    puts '2 - Mostrar frase descriptografada'
    puts '3 - Enviar teste'
    puts '0 - Sair'
    @option = gets.chomp
end

def show_register_token
    puts "TOKEN INVÁLIDO".center(60, '-')
    puts "Registre o seu token"
    puts "OBS: Para enviar o seu desafio você deve ter, em mãos, o seu"
    puts "token.Para isso faça login no site https://codenation.dev/ e "
    puts "clique na sua foto de perfil para visualizar o seu token"
    print "Token: "
    @token = gets.chomp
end

def show_decrypted_sentence
    @json = Token.is_valid?(@token)
    rotation = @json['numero_casas']
    cifred_sentence = @json['cifrado']
    decrypted_sentence = CesarCipher.decrypt(cifred_sentence, rotation)
    puts "*".center(60,"*")
    puts "A frase descriptografada é: #{decrypted_sentence[0..30]}"
    puts "#{decrypted_sentence[31..-1]}"
    puts "*".center(60,"*")
end

def show_send_test
    last_sent = (File.exist?('log.txt'))? IO.readlines("log.txt")[0].to_i : -60
    time_now = DateTime.now.strftime('%s').to_i

    if time_now > last_sent + 60
        Token.save_answer(@token)
        json = Token.send_test(@token)
        puts "*".center(60,"*")

        if(JSON.parse(json)['code'] == '429')
            puts "Você fez muitas requisições, aguarde alguns minutos"
        elsif JSON.parse(json)['code'] == '403'
            puts "Acesso proibido, o período de envio está encerrado" 
            puts "ou você não é um cadidato válido para o aceleradev"
        else
            score =  JSON.parse(json)['score']
            puts "Teste enviado com sucesso!"
            puts "Sua nota foi: " + score.to_s
        end

        puts "*".center(60,"*")
        File.write("log.txt", DateTime.now.strftime('%s'))
    else
        puts "*".center(60,"*")
        puts "Você só pode consultar um vez a cada minuto."
        puts "Aguarde #{last_sent + 60 - time_now} segundos"
        puts "*".center(60,"*")
    end
end

def clear_terminal
    system 'clear'
end

def token_is_valid?
    return false unless Token.is_valid?(@token)
    return true
end

while @option != "0"
    
    case @option
    when "1"
        clear_terminal()
        show_header()
        if token_is_valid?()
            show_options()
        else
            show_register_token()
        end
    when "2"
        clear_terminal()
        show_header()
        show_decrypted_sentence()
        show_options()
    when "3"
        clear_terminal()
        show_header()
        show_send_test()
        show_options()
    else
        clear_terminal()
        show_header()
        puts "*".center(60,"*")
        puts "Opção inválida. Tente uma das opções abaixo."
        puts "*".center(60,"*")
        show_options()
    end
end
