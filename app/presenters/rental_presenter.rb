class RentalPresenter < SimpleDelegator
  delegate :content_tag, to: :helper

  def initialize(rental)
    super(rental)
  end

  def status_badge
    content_tag :span, class: "badge badge-#{status_class}" do
      I18n.translate(status.to_s)
    end
  end

  private

  def helper
    ApplicationController.helpers
  end

  def status_class
    status_classes = {
      scheduled: 'primary',
      ongoing: 'info',
      in_review: '',
      finalized: 'success'
    }

    status_classes[status.to_sym]
  end
end
