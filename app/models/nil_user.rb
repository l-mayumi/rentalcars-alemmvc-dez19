class NilUser
  def admin?
    false
  end

  def subsidiary
    nil
  end

  def persisted?
    false
  end

  def rentals
    []
  end
end