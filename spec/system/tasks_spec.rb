require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
  describe 'Registration function' do
    context 'When registering a task' do
      it 'The registered task is displayed' do
        # 1. Visit the new task page
        visit new_task_path
        
        # 2. Fill in the form fields
        fill_in 'Title Title', with: 'My Test Task'
        fill_in 'Content', with: 'This is a test content.'
        
        # 3. Click the submit button
        click_button 'Create Task'
        
        # 4. Verify the flash message and new task content exist on the page
        expect(page).to have_content 'Task was successfully created.'
        expect(page).to have_content 'My Test Task'
      end
    end
  end

  describe 'List display function' do
    context 'When transitioning to the list screen' do
      it 'A list of registered tasks is displayed' do
        # 1. Create a task using FactoryBot
        FactoryBot.create(:task)
        
        # 2. Visit the list screen
        visit tasks_path
        
        # 3. Verify the factory task's title is on the page
        expect(page).to have_content 'Document preparation'
      end
    end
  end

  describe 'Detailed display function' do
     context 'When transitioned to any task details screen' do
       it 'The content of the task is displayed' do
         # 1. Create a task and store it in a variable
         task = FactoryBot.create(:task)
         
         # 2. Visit that specific task's show page
         visit task_path(task.id)
         
         # 3. Verify the title and content are displayed
         expect(page).to have_content 'Document preparation'
         expect(page).to have_content 'Create a proposal.'
       end
     end
  end
end