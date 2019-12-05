require 'rails_helper'

describe RentalBuilder do
  describe '.build' do
    it 'should build a rental instance' do
      client = create(:client)
      subsidiary = create(:subsidiary)
      manufacture = create(:manufacture)
      fuel_type = create(:fuel_type)
      category = create(:category, name: 'A', daily_rate: 10, car_insurance: 20,
                        third_party_insurance: 20)
      customer = create(:individual_client, name: 'Claudionor',
                        cpf: '318.421.176-43', email: 'cro@email.com')
      other_customer = create(:individual_client, name: 'Junior',
                      cpf: '323.231.116-3', email: 'junior@email.com')
      car_model = create(:car_model, name: 'Sedan', manufacture: manufacture,
                      fuel_type: fuel_type, category: category)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      create(:rental, category: category, subsidiary: subsidiary,
          start_date: '3000-01-02', end_date: '3000-01-03',
          client: other_customer)
      params = build(:rental, client: client, category: category,
                      start_date: 1.day.from_now, end_date: 2.days.from_now).attributes

      result = described_class.new(params, subsidiary).build

      expect(result).to be_valid
      expect(result).to be_scheduled
      expect(result.subsidiary).to eq subsidiary
      expect(result.reservation_code).to eq 'ABC123'
    #   expect(result.price_projection).to eq X
    end
  end
end