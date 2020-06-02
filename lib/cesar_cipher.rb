class CesarCipher
    def self.encript(sentence, rotation)
        encripted_sentence = ''
        sentence.downcase!
        sentence.each_char do |char|
            charcode = char.ord + rotation
            case charcode
            when 97..122 then encripted_sentence << (charcode).chr
            when 123..148 then encripted_sentence << (charcode -26).chr
            else encripted_sentence << char
            end
        end
        encripted_sentence
    end

    def self.decrypt(sentence, rotation)
        encripted_sentence = ''
        sentence.downcase!
        sentence.each_char do |char|
            charcode = char.ord - rotation
            case charcode
            when 97..122 then encripted_sentence << (charcode).chr
            when 71..96 then encripted_sentence << (charcode  + 26).chr
            else encripted_sentence << char
            end
        end
        encripted_sentence
    end
end
