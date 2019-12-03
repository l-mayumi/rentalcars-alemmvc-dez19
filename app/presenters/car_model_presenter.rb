class CarModelPresenter < SimpleDelegator
  delegate :content_tag, :concat, to: :helper

  def initialize(car_model)
    super(car_model)
  end

  def car_options
    content_tag :ul do
    __getobj__.car_options.each do |option|
        concat(content_tag(:li, option))
      end
    end
  end

  private

  def helper
    ApplicationController.helpers
  end

  def obj
    __getobj__
  end
end
