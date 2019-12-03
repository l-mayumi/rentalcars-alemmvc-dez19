require 'rails_helper'

describe CarModelPresenter do
  describe '#car_options' do
    it 'should render car options as an unordered list' do
      car_model = build(:car_model, car_options: 'ar condicionado, car play')

      result = CarModelPresenter.new(car_model.decorate).car_options

      expect(result).to eq '<ul><li>ar condicionado</li><li>car play</li></ul>'
    end
  end
end