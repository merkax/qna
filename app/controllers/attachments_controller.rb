class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment, only: :destroy

  def destroy
    @attachment.purge if current_user&.owner?(@attachment.record)
  end
  
  private
  
  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
