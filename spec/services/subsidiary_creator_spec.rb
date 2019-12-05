require 'rails_helper'

describe SubsidiaryCreator do
  describe '.create' do
    it 'should create a subsidiary' do
      create(:category, name: 'A', daily_rate: 51.0, car_insurance: 52.0,
            third_party_insurance: 53.0)
      create(:category, name: 'B', daily_rate: 54.0, car_insurance: 55.0,
            third_party_insurance: 56.0)

      subsidiary_params = attributes_for(:subsidiary)
      result = described_class.new(subsidiary_params).create()

      expect(result).to be_persisted
      expect(result.rental_prices.count).to eq(2)
    end
  end
end