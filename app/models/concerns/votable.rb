module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    votes.create!(user: user, value: 1) unless user_voted?(user)
  end

  def vote_down(user)
    votes.create!(user: user, value: -1) unless user_voted?(user)
  end

  def vote_cancel(user)
    votes.destroy_all if user_voted?(user)
  end

  def rating
    votes.sum(:value)
  end

  def user_voted?(user)
    votes.exists?(user: user)
  end
end
