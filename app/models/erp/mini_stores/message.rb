module Erp::MiniStores
  class Message < ApplicationRecord
    validates :name, :email, :phone, :content, :presence => true
  end
end
