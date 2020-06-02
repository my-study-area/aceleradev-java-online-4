class CesarCipher
    def self.encript(sentence, rotation)
        encripted_sentence = ''
        sentence.downcase!
        sentence.each_char do |char|
            charcode = char.ord + rotation
            if charcode < 122 && charcode > 96
                encripted_sentence << (charcode).chr
            elsif charcode > 122 
                encripted_sentence << (charcode -26).chr
            else
                encripted_sentence << char
            end
        end
        encripted_sentence
    end
    

end
