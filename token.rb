class Token
    def self.is_valid?(token) 
        begin
            url = "https://api.codenation.dev/v1/challenge/dev-ps/generate-data?token=#{token}"
            json = RestClient.get(url, headers={})
        rescue RestClient::ExceptionWithResponse => e
            json = e.response
            e.response
        end
        return false if(JSON.parse(json)['code'] == 'not_found') 
        JSON.parse(json)
    end

    def self.save_answer(token)
        json = {}
        begin
            url = "https://api.codenation.dev/v1/challenge/dev-ps/generate-data?token=#{token}"
            json = RestClient.get(url, headers={})
        rescue RestClient::ExceptionWithResponse => e
            json = e.response
            e.response
        end
        json_parsed = JSON.parse(json)
        rotation = json_parsed['numero_casas']
        cifred_sentence = json_parsed['cifrado']
        decrypted_sentence = CesarCipher.decrypt(cifred_sentence, rotation)
        json_parsed['decifrado'] = decrypted_sentence
        json_parsed['resumo_criptografico'] = decrypted_sentence.to_sha1
        File.open('./answer.json', 'w') do |line|
            line.puts(json_parsed.to_json)
        end
        json_parsed
    end

    def self.send_test(token)
        submition_url = "https://api.codenation.dev/v1/challenge/dev-ps/submit-solution?token=#{token}"

        begin
            response = RestClient.post(
                submition_url,
                {
                    multipart: true,
                    answer: File.new("./answer.json", 'rb')
                },
                headers = {accept: :json}
            )
        rescue RestClient::TooManyRequests => e
            response = e.response
        rescue RestClient::Forbidden => e
            response = e.response
        end
        response
    end
end
