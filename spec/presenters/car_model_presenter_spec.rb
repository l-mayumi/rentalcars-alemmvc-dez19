require 'rails_helper'

describe CarModelPresenter do
  describe '#options' do
    it 'should render as an unordered list' do
      car_model = build(:car_model, car_options: 'ar cond, teto solar, car play')
      result = CarModelPresenter.new(car_model.decorate).car_options

      expect(result).to eq '<ul><li>ar cond</li><li>teto solar</li><li>car play</li></ul>'
    end
  end
end
