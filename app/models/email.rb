class Email < ActiveRecord::Base
  validates :address, email: true
  belongs_to :contact
end
