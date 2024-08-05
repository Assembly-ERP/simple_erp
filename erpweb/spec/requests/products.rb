# spec/requests/products_spec.rb
require 'rails_helper'

 RSpec.describe "Products API", type: :request do
   let!(:products) { create_list(:product, 10) }
   let(:product_id) { products.first.id }
 
   describe "GET /api/v1/products" do
     before { get '/api/v1/products' }
 
     it 'returns products' do
       expect(json).not_to be_empty
       expect(json.size).to eq(10)
     end
 
     it 'returns status code 200' do
       expect(response).to have_http_status(200)
     end
   end
 
   # Additional tests for show, create, update, delete
 end