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
    item_params = {
        name: "Stapler",
        description: "it staples things",
        unit_price: 13.98,
        merchant_id: merchant.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can delete an item' do
    merchants = create_list(:merchant, 2)
    merchant1_items = create_list(:item, 5, merchant_id: merchants[0].id)
    item = create(:item, merchant_id: merchants[1].id)
    delete "/api/v1/items/#{item.id}"
    # expect(Item.count).to eq(6)
    # expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)

    # expect(response).to be_succesful
    # expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
