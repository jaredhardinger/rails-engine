require 'rails_helper'

RSpec.describe 'The merchants API' do
  it 'returns a list of all merchants' do
    create_list(:merchant, 10)

    get '/api/v1/merchants'

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchants = response_body[:data]

    merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes][:name]).to be_a(String)

        expect(merchant[:attributes]).to_not have_key(:created_at)
    end
  end

  it 'returns one merchant' do 
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)
    expect(merchant[:id].to_i).to be_an(Integer)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_a(String)

    expect(merchant[:attributes]).to_not have_key(:created_at)
  end

  it "returns the merchant's items" do 
    merchants = create_list(:merchant, 2)
    merchant1 = merchants[0]
    merchant2 = merchants[1]

    merchant1_items = create_list(:item, 5, merchant_id: merchant1.id)
    merchant2_items = create_list(:item, 4, merchant_id: merchant2.id)

    get "/api/v1/merchants/#{merchant1.id}/items"

    expect(response).to be_successful
    
    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

    expect(items.count).to eq(5)
    item_ids = items.map { |item| item[:id].to_i }
    merchant1_item_ids = merchant1_items.map(&:id)
    merchant2_item_ids = merchant2_items.map(&:id)
    expect(item_ids).to match(merchant1_item_ids)
    expect(item_ids).to_not match(merchant2_item_ids)
  end
end
