class Api::V1::MerchantsController < ApplicationController
    def index
        render json: MerchantSerializer.new(Merchant.all)
    end

    def show
        render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end

    def find_all
        if params[:name].empty?
            render status: 400
        else
            merchants = Merchant.find_by_name(params[:name])
            if merchants.empty?
                render json: MerchantSerializer.new(merchants), status: 404
            else
                render json: MerchantSerializer.new(merchants)
            end
        end
    end
end