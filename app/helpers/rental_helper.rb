module RentalHelper
  def status_badge(rental)
    if rental.scheduled?
      content_tag :span, class: 'badge badge-primary' do
        t(rental.status)
      end
    elsif rental.in_review?
      content_tag :span, class: 'badge badge-secondary' do
        t(rental.status)
      end
    elsif rental.ongoing?
      content_tag :span, class: 'badge badge-warning' do
        t(rental.status)
      end
    elsif rental.finalized?
      content_tag :span, class: 'badge badge-success' do
        t(rental.status)
      end
    end
  end
end