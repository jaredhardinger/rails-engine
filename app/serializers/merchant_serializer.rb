class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  def self.no_matches
    { data: {} }
  end
end
