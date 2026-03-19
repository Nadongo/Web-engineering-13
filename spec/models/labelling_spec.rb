require 'rails_helper'

RSpec.describe Labelling, type: :model do
  describe 'Validation tests' do
    # Create the prerequisite data using your existing factories
    let(:user) { FactoryBot.create(:user) }
    let(:task) { FactoryBot.create(:task, user: user) }
    let(:label) { FactoryBot.create(:label, user: user) }

    context 'When both task and label are present' do
      it 'is valid' do
        labelling = Labelling.new(task: task, label: label)
        expect(labelling).to be_valid
      end
    end

    context 'When task is missing' do
      it 'is invalid' do
        labelling = Labelling.new(label: label)
        expect(labelling).not_to be_valid
      end
    end

    context 'When label is missing' do
      it 'is invalid' do
        labelling = Labelling.new(task: task)
        expect(labelling).not_to be_valid
      end
    end
  end
end