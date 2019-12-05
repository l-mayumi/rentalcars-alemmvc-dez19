class SubsidiaryCreator
  attr_reader :params
  def initialize(params)
    @params = params
  end

  def create()
    subsidiary = Subsidiary.create(params)
    ActiveRecord::Base.transaction do
      subsidiary.save!
      categories = Category.all
      categories.each do |category|
        RentalPrice.create!(category: category, subsidiary: subsidiary,
                          daily_rate: category.daily_rate,
                          daily_car_insurance: category.car_insurance,
                          daily_third_party_insurance: category.third_party_insurance)
      end
      subsidiary
    end
  rescue ActiveRecord::RecordInvalid
    return subsidiary
  end
end