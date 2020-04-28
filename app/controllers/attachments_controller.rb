class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment, only: :destroy

  authorize_resource

  def destroy
    @attachment.purge
  end
  
  private
  
  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
