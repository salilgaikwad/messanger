class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :set_recipients, only: [:new, :create, :pay]

  before_action :check_authorization, only: [:show, :edit, :update, :destroy]
  

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/inbox
  # GET /messages/inbox.json
  def inbox
    @messages = current_user.received_messages
  end

  # GET /messages/sent
  # GET /messages/sent.json
  def sent
    @messages = current_user.sent_messages
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message.mark_as_read(current_user)
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create    
    @message = Message.new(message_params)
    @message.sender_id = current_user.id

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    
    respond_to do |format|
      if @message.destroy
        format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to sent_messages_url, notice: 'cannot delete message that has already been read' }
        format.json { head :no_content }
      end
      
    end
  end

  def pay
    session[:payee_id], session[:amount] = nil, nil
  end

  def pay_user
    session[:payee_id], session[:amount] = params[:recipient_id], params[:amount].to_i
    errors = validate_payment_details
    
    respond_to do |format|
      if errors.blank?
        format.html { redirect_to new_charge_url }
        format.json { head :no_content }
      else
        format.html { redirect_to pay_messages_url, notice: errors.join(', ') }
        format.json { head :no_content }
      end
      
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    def set_recipients
      @recipients = User.recipients(current_user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:title, :content, :sender_id, :recipient_id, :read)
    end

    def check_authorization
      unless @message.sender?(current_user.id) || @message.recipient?(current_user.id)
        redirect_to messages_url, alert: 'You are not authorized to view this message.'
      end
    end

    def validate_payment_details
      errors = []
      user = User.find_by_id session[:payee_id]
      unless user && user.publishable_key
        errors << 'Invalid Payee'
      end
      if session[:amount].to_i.zero? || session[:amount].to_i < 500
        errors << 'Invalid Amount'
      end
      errors
    end

end
