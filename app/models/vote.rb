class Vote < ApplicationRecord
  belongs_to :campaign
  belongs_to :candidate
  
  enum validity: [:during, :pre, :post]
end
