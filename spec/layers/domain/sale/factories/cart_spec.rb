require 'rails_helper'

RSpec.describe Domain::Sale::Factories::Cart do
  describe '#build' do
    it 'returns object' do
      dto = OpenStruct.new(id: nil, last_activity_at: nil, abandoned: false)
      subject = described_class.build(dto)

      expect(subject).to be_a Domain::Sale::Cart

      expect(subject.total_price).to eq(dto.total_price)
      expect(subject.last_activity_at).to eq(dto.last_activity_at)
      expect(subject.abandoned).to be_falsey
    end
  end
end
