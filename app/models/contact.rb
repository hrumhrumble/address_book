class Contact < ActiveRecord::Base
  validates_uniqueness_of :first_name, scope: :last_name
  validates_presence_of :first_name, :last_name

  has_many :phones, dependent: :destroy
  has_many :emails, dependent: :destroy

  accepts_nested_attributes_for :phones, :emails, :allow_destroy => true

end
