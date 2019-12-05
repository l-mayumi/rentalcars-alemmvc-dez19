class TokenGenerator

  def initialize
    reservation_code = loop do
      token = self.generate_token
      break token unless Rental.exists?(reservation_code: token)
    end
  end

  def generate_token
    charset = Array('A'..'Z') + Array(0..9)
    Array.new(6) { charset.sample }.join
  end
end