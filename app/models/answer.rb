class Answer < ApplicationRecord
  default_scope { order(best: :desc).order(:created_at) }

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  
  has_many_attached :files
  
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  
  validates :body, presence: true

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end
end
