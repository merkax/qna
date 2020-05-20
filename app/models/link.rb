class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, :url, presence: true
  validates :url, on: :create,
            format: { with: %r{(http|https)://[a-zA-Z0-9\-\#/\_]+[\.][a-zA-Z0-9\-\.\#/\_]+}i,
                      message: 'please enter the URL in the correct format' }
                      
  def gist?
    url.match? 'https://gist.github.com/'
  end
end
