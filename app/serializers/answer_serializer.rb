class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at
  
  has_many :comments
  has_many :files
  has_many :links

  def files
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end

  def links
    object.links.map(&:name)
  end
end
