require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'class methods' do
    it 'can find by name' do
      merchant1 = create(:merchant, name: "Steve")
      merchant2 = create(:merchant, name: "Stephen")
      merchant3 = create(:merchant, name: "Styven")

      expect(Merchant.find_by_name("Ste").to_a).to eq([merchant2, merchant1])
    end
  end
end
