require 'rails_helper'

describe RentalPresenter do
  describe '#status' do
    it 'should render primary badge' do
      rental = build(:rental, status: :scheduled)
      result = RentalPresenter.new(rental).status_badge
      expect(result).to eq('<span class="badge badge-primary">agendada</span>')
    end


  end
end
