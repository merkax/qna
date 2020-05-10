require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question } 
    it { should be_able_to :read, Answer } 
    it { should be_able_to :read, Comment } 
    
    it { should_not be_able_to :manage, :all } 
  end
  
  describe 'for admin' do
    let(:user) { create(:user, admin: true) } 
    
    it { should be_able_to :manage, :all } 
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question_user) {create(:question, user: user) } 
    let(:question_other_user) {create(:question, user: other_user) }
    let(:answer_user) {create(:answer, user: user) }
    let(:answer_other_user) {create(:answer, user: other_user) }
    
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    
    context "Question" do
      it { should be_able_to :create, Question }

      it { should be_able_to [:update, :destroy], question_user }
      it { should_not be_able_to [:update, :destroy], question_other_user }

      it { should be_able_to [:vote_up, :vote_down, :vote_cancel], question_other_user } 
      it { should_not be_able_to [:vote_up, :vote_down, :vote_cancel], question_user } 
    end
    

    context "Answer" do
      it { should be_able_to :create, Answer } 
      
      it { should be_able_to [:update, :destroy], answer_user }
      it { should_not be_able_to [:update, :destroy], answer_other_user }
      
      it { should be_able_to :set_best, create(:answer, question: question_user) }
      it { should_not be_able_to :set_best, create(:answer, question: question_other_user) }
      
      it { should be_able_to [:vote_up, :vote_down, :vote_cancel], answer_other_user }
      it { should_not be_able_to [:vote_up, :vote_down, :vote_cancel], answer_user }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context "Link" do
      it { should be_able_to :destroy, create(:link, linkable: question_user) }
      it { should_not be_able_to :destroy, create(:link, linkable: question_other_user) }
      it { should be_able_to :destroy, create(:link, linkable: answer_user) }
      it { should_not be_able_to :destroy, create(:link, linkable: answer_other_user) }
    end
    
    context "Attachment" do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end

    context "Profiles" do
      it { should be_able_to :me, user }
      it { should_not be_able_to :me, other_user }

      it { should be_able_to :index, user }
      it { should be_able_to :index, other_user }
    end

    context "Subscription" do
      it { should be_able_to :create, Subscription }

      it { should be_able_to :destroy, create(:subscription, user: user) }
      it { should_not be_able_to :destroy, create(:subscription,user: other_user) }
    end
  end
end
