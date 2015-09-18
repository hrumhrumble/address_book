class ShareMailer < ApplicationMailer
  default from: 'notifications@address-book.com'

  def share(email, contact)
    @contact_data = contact
    mail(to: email, subject: 'Contact from Address Book')
  end

end
