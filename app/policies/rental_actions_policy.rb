class RentalActionsPolicy
  attr_reader :user

  def initialize(rental, user)
    @rental = rental
    @user = user
  end

  def authorized?
    user.admin? || user.subsidiary == @rental.subsidiary
  end
end
