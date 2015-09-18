class Contact < ActiveRecord::Base
  validates_uniqueness_of :first_name, scope: :last_name
  validates_presence_of :first_name, :last_name
  validate :have_one_email_or_phone

  has_many :phones, dependent: :destroy
  has_many :emails, dependent: :destroy

  accepts_nested_attributes_for :phones, :emails, :allow_destroy => true, reject_if: :all_blank

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      @contact = Contact.where(first_name: row['first_name'], last_name: row['last_name'])

      if @contact.present?
        Contact.destroy(@contact)
        new_contact(row)
      else
        new_contact(row)
      end
    end
  end

  def self.new_contact(row)
    @new_contact = Contact.new
    @new_contact.first_name = row['first_name']
    @new_contact.last_name = row['last_name']

    row['phones'].split(',').each do |phone|
      @new_contact.phones.build({number: phone})
    end
    row['emails'].split(',').each do |email|
      @new_contact.emails.build({address: email})
    end
    @new_contact.save!
  end


  private

  def have_one_email_or_phone
    if self.phones.size <= 0 && self.emails.size <= 0
      errors.add(:base, 'Must have at least one email or phone')
    end
  end

end
