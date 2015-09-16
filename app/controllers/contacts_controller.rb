class ContactsController < ApplicationController
  before_action :set_contact, only: [:destroy, :show]

  def index
    @contacts = Contact.all
  end

  def new
    @contact = Contact.new
    @contact.phones.build
    @contact.emails.build
  end

  def show
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to root_path
      flash[:notice] = 'Contact was created successfully'
    else
      render :new
    end
  end

  def destroy
    if @contact.destroy
      redirect_to root_path, notice: 'Contact removed'
    else
      raise 'Unable to destroy contact'
    end
  end

  private
  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, phones_attributes: [:id, :number, :_destroy], emails_attributes: [:id, :address, :_destroy])
  end
end
