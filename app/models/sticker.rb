class Sticker < ActiveRecord::Base
  attr_accessible :message_id, :product_id, :code, :user_id, :production_date, :activated, :verified, :verifier
  belongs_to :user
  belongs_to :message

  validates :product_id, :code, :presence => true

  def self.can_import_from_csv?
    true
  end

end
