require 'rails_helper'

describe RentalHelper do
  describe '.status_badge' do
    it 'should render primary badge' do
      rental = build(:rental, status: :scheduled)

      result = helper.status_badge(rental)

      expect(result).to eq('<span class="badge badge-primary">agendada</span>')
    end

    it 'should render success badge' do
      rental = build(:rental, status: :finalized)

      result = helper.status_badge(rental)

      expect(result).to eq('<span class="badge badge-success">finalizada</span>')
    end

  end
end
