# frozen_string_literal: true

class PagarMePix
  class ConectionError < StandardError; end

  def self.create(**opts)
    bar = [ 1, 2, 3, 4, 5, 6 ].sample
    if bar.even?
      raise ConectionError, "Conection Error"
    else
      {
        url: "http://pixurl.com.io"
      }
    end
  end
end
