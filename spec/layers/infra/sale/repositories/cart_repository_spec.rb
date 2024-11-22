require 'rails_helper'

describe Infra::Sale::Repositories::CartRepository, type: :class do
  subject { described_class.new }
  let(:cart) { build :cart }

  describe '#save!' do
    it 'call the models save! method' do
      model = double
      allow(model).to(receive(:save!))

      subject.save!(model)
      expect(model).to(have_received(:save!))
    end
  end


  describe '#find_by_id!' do
    it 'call the models find method' do
      model = Domain::Sale::Cart
      allow(model).to(receive(:find_by))

      subject.find_by(1)
      expect(model).to(have_received(:find_by))
    end
  end
end
