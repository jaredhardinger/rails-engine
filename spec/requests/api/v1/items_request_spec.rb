require 'rails_helper'

RSpec.describe 'The items API' do
  it 'returns a list of all items' do
    merchants = create_list(:merchant, 2)
    merchant1_items = create_list(:item, 5, merchant_id: merchants[0].id)
    merchant2_items = create_list(:item, 4, merchant_id: merchant[1].id)

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
    
    expect(Item.count).to eq(6)
    expect{ delete "/api/v1/items/#{item.id}" }.to change(Item, :count).by(-1)
    expect(response).to be_successful
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can update an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    item_params = {
        name: "Stapler",
        description: "it staples things",
        unit_price: 13.98,
        merchant_id: merchant.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: item_params)
    updated_item = Item.find_by(id: item.id)

    expect(response).to be_successful
    expect(updated_item.name).to_not eq(item.name)
    expect(updated_item.name).to eq("Stapler")
  end

  it "can get an item's merchant" do
    merchants = create_list(:merchant, 5)
    merchant1_items = create_list(:item, 5, merchant_id: merchants[0].id)
    merchant2_items = create_list(:item, 4, merchant_id: merchants[1].id)
    item1 = merchant1_items[3]
    item2 = merchant2_items[2]

    get "/api/v1/items/#{item1.id}/merchant"
    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    merchant = response_body[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)
    expect(merchant[:id].to_i).to be_an(Integer)

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'can find one item by name fragment' do 
    merchant = create(:merchant)
    item1 = create(:item, name: 'woodchuck repellent', merchant_id: merchant.id)
    item2 = create(:item, name: 'apple sauce', merchant_id: merchant.id)
    item3 = create(:item, name: 'nunchucks', merchant_id: merchant.id)

    get "/api/v1/items/find?name=uc"
    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]
    expect(item[:id].to_i).to eq(item2.id)
    expect(item[:attributes][:name]).to eq(item2.name)

    get "/api/v1/items/find?name=wood"
    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]
    expect(item[:id].to_i).to eq(item1.id)
    expect(item[:attributes][:name]).to eq(item1.name)

    get "/api/v1/items/find?name=shibby"
    expect(response).to_not be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]
    expect(item.empty?).to be(true)
  end
   
  it 'can find all items by name fragment' do 
    merchant = create(:merchant)
    item1 = create(:item, name: 'woodchuck repellent', merchant_id: merchant.id)
    item2 = create(:item, name: 'apple sauce', merchant_id: merchant.id)
    item3 = create(:item, name: 'nunchucks', merchant_id: merchant.id)

    get "/api/v1/items/find_all?name=uc"
    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]
    expect(items).to be_an(Array)
    expect(items.count).to eq(3)

    get "/api/v1/items/find_all?name=wood"
    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]
    expect(item[0][:id].to_i).to eq(item1.id)
    expect(item.count).to eq(1)
    expect(item[0][:attributes][:name]).to eq(item1.name)

    get "/api/v1/items/find?name=shibby"
    expect(response).to_not be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    item = response_body[:data]
    expect(item.empty?).to be(true)
  end
end
