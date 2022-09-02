class Merchant < ApplicationRecord
    has_many :items

    def self.find_by_name(search)
        where("name ilike ?", "%#{search}%")
        .order(:name)
    end
end
