require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                      "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Returns successful status'

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end
      
      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:users) { create_list(:user, 2) }
      let(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Returns successful status'

      it 'returns list of users without me' do
        expect(json['users'].size).to eq(users.size - 1)
      end

      it 'not returns me' do
        expect(json['users'].map(&:user['id'])).to_not eq include(me.id)
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['users'].last[attr]).to eq users.last.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['users'].first).to_not have_key(attr)
        end
      end
    end
  end
end
