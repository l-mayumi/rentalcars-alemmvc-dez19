class RentalBuilder
  attr_reader :params, :subsidiary
  def initialize(params, subsidiary, token_generator = TokenGenerator)
    @params = params
    @subsidiary = subsidiary
  end

  def build
    @rental = Rental.new(params)
    @rental.subsidiary = subsidiary
    @rental.status = :scheduled
    @rental
  end
end