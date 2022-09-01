require 'rails_helper'

RSpec.describe 'The items API' do
  it 'returns a list of all items' do
    create_list(:item, 10)

    get '/api/v1/items'

    expect(response).to be_successful

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]
  end
end
