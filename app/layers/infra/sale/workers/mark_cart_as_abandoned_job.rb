# frozen_string_literal: true

module Infra
  module Sale::Workers
    class MarkCartAsAbandonedJob
      include Sidekiq::Job

      def perform(*args)
        mark_abandoned_carts
        remove_old_abandoned_carts
      end

      private

      def mark_abandoned_carts
        Domain::Sale::Cart.where('last_activity_at < ? AND abandoned = ?', 3.hours.ago, false)
                          .in_batches(of: 500)
                          .update_all(abandoned: true)
      end

      def remove_old_abandoned_carts
        Domain::Sale::Cart.where('abandoned = ? AND last_activity_at < ?', true, 7.days.ago)
                          .destroy_all
      end
    end
  end
end

