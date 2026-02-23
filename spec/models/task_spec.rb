require 'rails_helper'

RSpec.describe 'Task model function', type: :model do
  describe 'Validation test' do
    
    context 'If the task Title is an empty string' do
      it 'Validation fails' do
        task = Task.new(title: '', content: 'Create a proposal.')
        expect(task).not_to be_valid
      end
    end

    # 2.an empty description (content)
    context 'If the task description is empty' do
      it 'Validation fails' do
        # We give the title a value, but leave the content empty
        task = Task.new(title: 'Document preparation', content: '')
        expect(task).not_to be_valid
      end
    end

    # 3.for a successful registration
    context 'If the task Title and description have values' do
      it 'You can register a task' do
        
        task = Task.new(title: 'Document preparation', content: 'Create a proposal.')
        
        expect(task).to be_valid
      end
    end

  end
end