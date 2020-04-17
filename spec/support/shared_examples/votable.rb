require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) } 

  describe 'instance methods' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:model) { described_class } 
    let!(:votable) { create(model.to_s.underscore.to_sym) }
    
    it '#vote_up' do
      votable.vote_up(user)

      expect(votable.rating).to eq 1
      expect(Vote.last.value).to eq 1
    end

    it '#vote_down' do
      votable.vote_down(user)

      expect(votable.rating).to eq -1
      expect(Vote.last.value).to eq -1
    end

    it '#vote_cancel' do
      votable.vote_up(user)
      expect(votable.rating).to eq 1

      votable.vote_cancel(user)
      expect(votable.rating).to eq 0
    end

    it '#rating' do
      votable.vote_up(user)
      votable.vote_up(another_user)

      expect(votable.rating).to eq 2
    end

    describe '#user_voted?' do
      before { votable.vote_up(user) }
      
      it 'true #user_voted' do
        expect(votable).to be_user_voted(user)
      end
      
      it 'false #user_voted' do
        expect(votable).to_not be_user_voted(another_user)
      end
    end
  end
end


