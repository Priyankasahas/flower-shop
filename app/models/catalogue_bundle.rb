class CatalogueBundle < ApplicationRecord
  def self.all_bundles_by_code(code)
    where(code: code).order(:quantity)
  end
end
