module Linkable
  extend ActiveSupport::Concern

  included do
    has_many :links, dependent: :destroy, as: :linkable
    accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  end
end
