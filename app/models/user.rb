class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :awards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:github, :vkontakte]

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def owner?(resource)
    resource.user_id == id
  end

  def subscribed?(resource)
    resource.subscriptions.where(user: self).exists?
  end
end
