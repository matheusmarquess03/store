require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Infra::Sale::Workers::MarkCartAsAbandonedJob, type: :job do
  before do
    Sidekiq::Testing.inline!
  end

  describe '#perform' do
    it 'calls mark_abandoned_carts and remove_old_abandoned_carts' do
      job_instance = described_class.new

      expect(job_instance).to receive(:mark_abandoned_carts).and_call_original
      expect(job_instance).to receive(:remove_old_abandoned_carts).and_call_original

      job_instance.perform
    end
  end
end
