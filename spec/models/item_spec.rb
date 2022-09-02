require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
  end

  describe 'class methods' do 
    it 'can find by name' do 
      merchant = create(:merchant)
      item1 = create(:item, name: "Green Egg", merchant: merchant)
      item2 = create(:item, name: "Ham", merchant: merchant)
      item3 = create(:item, name: "Fried Elephant", merchant: merchant)
      item4 = create(:item, name: "Ivory", merchant: merchant)

      expect(Item.find_by_name("e").to_a).to eq([item3, item1])
    end
  end
end
