# frozen_string_literal: true

class PagarMe::Boleto
  class ConnectionError < StandardError; end

  def self.create(**opts)
    bar = [ 1, 2, 3, 4, 5, 6 ].sample
    if bar.even?
      raise ConnectionError, "Conection Error"
    else
      {
        url: "http://boleto.com.io"
      }
    end
  end
end
