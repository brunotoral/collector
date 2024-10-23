# frozen_string_literal: true

class PagarMe::Card
  class ConnectionError < StandardError; end
  class NoFundsError < StandardError; end

  def self.create(opts = {})
    {
      token: SecureRandom.urlsafe_base64,
      brand: %w[Visa Mastercard AmericanExpress Discover].sample,
      last_digits: opts[:number][-4..-1],
      expiration_date: opts[:expiration_date]
    }
  end

  def self.charge(**opts)
    bar = [ 1, 2, 3, 4, 5, 6 ].sample
    if [ 1, 2 ].include? bar
      raise ConnectionError, "Connection Error"
    elsif [ 3, 4 ].include? bar
      raise NoFundsError, "Does not have money"
    else
      true
    end
  end
end
