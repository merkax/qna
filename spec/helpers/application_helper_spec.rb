require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#javascript_link_tag" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:link) { create(:link, :gist_valid_url, linkable: question) }

    it 'returns the gist render ready tag' do
      expect(javascript_link_tag(link)).to eq('<script src=' + link.url + '.js></script>')
    end
  end
end
