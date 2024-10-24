# frozen_string_literal: true

class PagarMe::Boleto
  class ConnectionError < StandardError; end

  def self.create(**opts)
    bar = [ 1, 2 ].sample
    if bar == 1
      raise ConnectionError, "Conection Error"
    else
      {
        url: "http://boleto.com.io"
      }
    end
  end
end
