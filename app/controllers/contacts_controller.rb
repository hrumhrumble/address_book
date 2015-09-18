class ContactsController < ApplicationController
  before_action :set_contact, only: [:destroy, :show, :edit, :update]

  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html
      format.csv { send_data @contacts.to_csv }
    end
  end

  def new
    @contact = Contact.new
    @contact.phones.build
    @contact.emails.build
  end

  def show
  end

  def edit
  end

  def update
    if @contact.update_attributes(contact_params)
      redirect_to root_path
      flash[:success] = "Successfully updated"
    else
      render :edit
    end

  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to root_path
      flash[:success] = 'Contact was created successfully'
    else
      render :new
    end
  end

  def destroy
    if @contact.destroy
      redirect_to root_path
      flash[:success] = 'Contact removed'
    else
      raise 'Unable to destroy contact'
    end
  end

  def import
    @file = params[:file]
    if @file.nil?
      redirect_to root_path
      flash[:danger] = 'Empty file'
    else
      @file = Contact.import(params[:file])
      redirect_to root_path
      flash[:success] = 'Import success'
    end

  end

  def share
    @email = params[:form][:share_email]
    @contact = {
        first_name: params[:first_name],
        last_name: params[:last_name],
        phones: params[:phones],
        emails: params[:emails]
    }

    if @email
      ShareMailer.share(@email, @contact).deliver_later
    else
      redirect_to root_path
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
