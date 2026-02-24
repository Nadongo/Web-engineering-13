require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
  describe 'Registration function' do
    context 'When registering a task' do
      it 'The registered task is displayed' do
        visit new_task_path
        
        # Updated to use the new i18n labels
        fill_in 'Title', with: 'My Test Task'
        fill_in 'content', with: 'This is a test content.'
        click_button 'register'
        
        # Updated to expect the new flash message
        expect(page).to have_content 'I have registered a task'
        expect(page).to have_content 'My Test Task'
      end
    end
  end

  describe 'List display function' do
    # Using let! to create 3 tasks with different dates before the tests run
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: '2025-02-18') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2025-02-17') }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: '2025-02-16') }

    # Using before to visit the page once before each 'it' block
    before do
      visit tasks_path
    end

    context 'When transitioning to the list screen' do
      it 'A list of registered tasks is displayed' do
        expect(page).to have_content 'first_task'
        expect(page).to have_content 'second_task'
        expect(page).to have_content 'third_task'
      end

      it 'The list of created tasks is displayed in descending order of creation date and time.' do
        # Grabs all the table rows inside the <tbody>
        task_list = all('tbody tr')
        
        # Checks if the newest task (first_task) is at the very top (index 0)
        expect(task_list[0]).to have_content 'first_task'
        expect(task_list[1]).to have_content 'second_task'
        expect(task_list[2]).to have_content 'third_task'
      end
    end

    context 'When creating a new task' do
      it 'New task is displayed at the top' do
        visit new_task_path
        fill_in 'Title', with: 'newly_created_task'
        fill_in 'content', with: 'new task content'
        click_button 'register'

        expect(page).to have_content 'I have registered a task'
        
        # Verify the brand new task is at the very top of the list
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'newly_created_task'
      end
    end
  end

  describe 'Detailed display function' do
     context 'When transitioned to any task details screen' do
       it 'The content of the task is displayed' do
         task = FactoryBot.create(:task, title: 'Document preparation', content: 'Create a proposal.')
         visit task_path(task.id)

         expect(page).to have_content 'Document preparation'
         expect(page).to have_content 'Create a proposal.'
       end
     end
  end
end