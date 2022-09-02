class Api::V1::ItemMerchantController < ApplicationController
    def show
        if Item.exists?(params[:item_id])
            item = Item.find(params[:item_id])
            merchant = item.merchant
            render json: MerchantSerializer.new(merchant)
        else
            render status: 404
        end
    end
end