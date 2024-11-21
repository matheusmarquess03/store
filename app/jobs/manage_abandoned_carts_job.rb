class ManageAbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Cart.where('last_activity_at < ?', 3.hours.ago)
    #     .where(abandoned: false)
    #     .update_all(abandoned: true)

    Cart.where('last_activity_at < ?', 3.hours.ago)
        .where(abandoned: false)
        .in_batches(of: 500)
        .update_all(abandoned: true)

    Cart.where('abandoned = ? AND last_activity_at < ?', true, 7.days.ago)
        .destroy_all
  end
end
