class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :award, dependent: :destroy
  
  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :calculate_reputation, :subscription_for_author

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscription_for_author
    subscriptions.create(user: user)
  end
end
