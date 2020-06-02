require 'cesar_cipher'

describe 'cesar_cipher' do
  context '#encript' do
    it 'o retorno é uma frase minúscula' do
        expect(CesarCipher.encript("A", 2)).to match(/[a-z]/)
        expect(CesarCipher.encript('A', 2)).to eq("c")
    end

    it 'encripta frase com salto de 1' do
        expect(CesarCipher.encript('AbC', 1)).to eq('bcd')
    end

    it 'reinicia alfabeto após a rotação passar da letra "Z"' do
        expect(CesarCipher.encript'z', 1).to eq('a')
        expect(CesarCipher.encript'macaco', 1).to eq('nbdbdp')
    end

    it 'não encripta ponto "."' do
        expect(CesarCipher.encript('a.a', 3)).to eq('d.d')
    end

    it 'não encripta ponto números' do
        expect(CesarCipher.encript('a1a', 3)).to eq('d1d')
    end
  end
end
