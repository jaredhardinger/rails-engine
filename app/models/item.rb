class Item < ApplicationRecord
    belongs_to :merchant

    def self.find_by_name(search)
        where("name ilike ?", "%#{search}%")
        .order(:name)
        .first
    end
end
