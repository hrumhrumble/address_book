class Phone < ActiveRecord::Base
  validates_numericality_of :number
  belongs_to :contact
end
