class Contact < ActiveRecord::Base
  validates_uniqueness_of :first_name, scope: :last_name
  validates_presence_of :first_name, :last_name
  validate :have_one_email_or_phone

  has_many :phones, dependent: :destroy
  has_many :emails, dependent: :destroy

  accepts_nested_attributes_for :phones, :emails, :allow_destroy => true, reject_if: :all_blank

  private
  def have_one_email_or_phone
    if self.phones.size <= 0 && self.emails.size <= 0
      errors.add(:base, 'Must have at least one email or phone')
    end
  end

end
