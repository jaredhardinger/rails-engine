class Api::V1::ItemsController < ApplicationController
    def index
        render json: ItemSerializer.new(Item.all)
    end

    def show
        render json: ItemSerializer.new(Item.find(params[:id]))
    end

    def create
        item = Item.create(item_params)
        if item.save
            render json: ItemSerializer.new(item), status: 201
        else
            render status: 404
        end
    end

    def destroy
        if Item.exists?(params[:id])
            render json: Item.delete(params[:id])
        else
            render status: 404
        end
    end

    def update
        item = Item.update(params[:id], item_params)
        if item.save
            render json: ItemSerializer.new(item), status: 201
        else
            render status: 404
        end
    end

    def find
        if params[:name].empty?
            render status: 400
        else
            item = Item.find_by_name(params[:name]).first
            if item.nil?
                render json: ItemSerializer.no_matches, status: 404
            else
                render json: ItemSerializer.new(item)
            end
        end
    end

    def find_all
        if params[:name].empty?
            render status: 400
        else
            items = Item.find_by_name(params[:name])
            if items.empty?
                render json: ItemSerializer.no_matches, status: 404
            else
                render json: ItemSerializer.new(items)
            end
        end
    end

private
    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end