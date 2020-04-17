class Answer < ApplicationRecord
  include Linkable
  include Votable

  default_scope { order(best: :desc).order(:created_at) }

  belongs_to :question
  belongs_to :user
  
  has_many_attached :files # переносить в concern/attachable ?
  
  validates :body, presence: true

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end
end
