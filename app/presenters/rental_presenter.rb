class RentalPresenter < SimpleDelegator
  attr_reader :user, :authorizer
  include Rails.application.routes.url_helpers
  delegate :content_tag, :link_to, to: :helper

  def initialize(rental, user, authorizer = RentalActionsPolicy)
    super(rental)
    @user = user || nil
    @authorizer = authorizer
  end

  def status_badge
    content_tag :span, class: "badge badge-#{status_class}" do
      I18n.translate(status.to_s)
    end
  end

  def current_action
    return '' unless authorizer.new(__getobj__, user).authorized?
    if scheduled?
      link_to 'Iniciar Locação', review_rental_path(id)
    elsif ongoing?
      link_to 'Encerrar Locação', closure_review_rental_path(id)
    elsif in_review?
      link_to 'Continuar Locação', review_rental_path(id)
    elsif finalized? && user.admin?
      link_to 'Reportar Problema', report_rental_path(id)
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
