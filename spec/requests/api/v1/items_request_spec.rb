require 'rails_helper'

RSpec.describe 'The items API' do
  it 'returns a list of all items' do
    merchants = create_list(:merchant, 2)
    merchant1 = merchants[0]
    merchant2 = merchants[1]
    merchant1_items = create_list(:item, 5, merchant_id: merchant1.id)
    merchant2_items = create_list(:item, 4, merchant_id: merchant2.id)

    get '/api/v1/items'

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

    expect(items.count).to eq(9)
    items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item).to have_key(:attributes)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)

        expect(item[:attributes]).to_not have_key(:created_at)
    end
  end

  it 'returns one item' do 
    merchant = create(:merchant)
    merchant_items = create_list(:item, 5, merchant_id: merchant.id)
    item = merchant_items[0]

    get "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]

    expect(response_body.count).to eq(1)
    expect(item).to have_key(:id)
    expect(item[:id]).to be_a(String)
    expect(item[:id].to_i).to be_an(Integer)

    expect(item).to have_key(:attributes)
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes][:description]).to be_a(String)
    expect(item[:attributes][:unit_price]).to be_a(Float)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)

    expect(item[:attributes]).to_not have_key(:created_at)
  end

  it 'can create an item' do 
    merchant = create(:merchant)
    params = {
        name: "Stapler",
        description: "it staples things",
        unit_price: 13.98,
        merchant_id: merchant.id
    }

  end
end
