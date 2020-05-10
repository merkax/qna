require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:answer) { create(:answer) }

  it 'calls NewAnswerNotificationService#call' do
    expect(NewAnswerNotificationService).to receive(:call).with(answer)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
