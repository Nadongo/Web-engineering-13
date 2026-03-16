require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  describe 'Registration function' do
    context 'When registering a task' do
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end

      it 'The registered task is displayed' do
        visit new_task_path
        fill_in 'タイトル', with: 'My Test Task'
        fill_in '内容', with: 'This is a test content.'
        
        # Uses TAB to safely lock the date in Headless Chrome
        fill_in '終了期限', with: '2026-12-31'
        find_field('終了期限').send_keys(:tab)
        
        select '中', from: '優先度'
        select '未着手', from: 'ステータス'
        
        click_button 'create-task'
        
        expect(page).to have_content 'My Test Task'
      end
    end
  end

  describe 'List display function' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: '2025-02-18', deadline_on: '2022-02-18', priority: 'medium', status: 'not_started', user: user) }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2025-02-17', deadline_on: '2022-02-17', priority: 'high', status: 'in_progress', user: user) }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: '2025-02-16', deadline_on: '2022-02-16', priority: 'low', status: 'completed', user: user) }

    before do
      visit new_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
      visit tasks_path
    end

    context 'When transitioning to the list screen' do
      it 'A list of registered tasks is displayed' do
        expect(page).to have_content 'first_task'
        expect(page).to have_content 'second_task'
        expect(page).to have_content 'third_task'
      end

      it 'The list of created tasks is displayed in descending order of creation date and time.' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'first_task'
        expect(task_list[1]).to have_content 'second_task'
        expect(task_list[2]).to have_content 'third_task'
      end
    end

    context 'When creating a new task' do
      it 'New task is displayed at the top' do
        visit new_task_path
        fill_in 'タイトル', with: 'newly_created_task'
        fill_in '内容', with: 'new task content'
        
        fill_in '終了期限', with: '2026-12-31'
        find_field('終了期限').send_keys(:tab)
        
        select '中', from: '優先度'
        select '未着手', from: 'ステータス'

        click_button 'create-task'

        visit tasks_path 
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'newly_created_task'
      end
    end

    describe 'sort function' do
      context 'If you click on the link "Exit Deadline"' do
        it "A list of tasks sorted in ascending order of due date is displayed." do
          click_link '終了期限'
          sleep 0.5
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content 'third_task'
          expect(task_list[1]).to have_content 'second_task'
          expect(task_list[2]).to have_content 'first_task'
        end
      end

      context 'If you click on the link "Priority"' do
        it "A list of tasks sorted by priority is displayed" do
          click_link '優先度'
          sleep 0.5
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content 'second_task'
          expect(task_list[1]).to have_content 'first_task'
          expect(task_list[2]).to have_content 'third_task'
        end
      end
    end

    describe 'Search function' do
      context 'If you do a fuzzy search by Title' do
        it "Only tasks containing the search word will be displayed." do
          fill_in 'タイトル', with: 'first'
          click_button 'search_task'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end

      context 'Search by status' do
        it "Only tasks matching the searched status will be displayed" do
          select '未着手', from: 'ステータス'
          click_button 'search_task'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'

          select '着手中', from: 'ステータス'
          click_button 'search_task'
          expect(page).not_to have_content 'first_task'
          expect(page).to have_content 'second_task'
          expect(page).not_to have_content 'third_task'

          select '完了', from: 'ステータス'
          click_button 'search_task'
          expect(page).not_to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).to have_content 'third_task'
        end
      end

      context 'Title and search by status' do
        it "Only tasks that contain the search word Title and match the status will be displayed" do
          fill_in 'タイトル', with: 'first'
          select '未着手', from: 'ステータス'
          click_button 'search_task'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end

      context 'When searching by label' do
        # Create the label BEFORE the page loads to prevent session dropping
        let!(:search_label) { FactoryBot.create(:label, name: '検索用ラベル', user: user) }
        let!(:labelling) { FactoryBot.create(:labelling, task: first_task, label: search_label) }

        it 'All tasks with that label are displayed.' do
          visit tasks_path
          
          select '検索用ラベル', from: 'search[label_id]'
          click_button 'search_task'
          
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end
    end
  end

  describe 'Detailed display function' do
     context 'When transitioned to any task details screen' do
       before do
         visit new_session_path
         fill_in 'メールアドレス', with: user.email
         fill_in 'パスワード', with: 'password'
         click_button 'ログイン'
       end

       it 'The content of the task is displayed' do
         task = FactoryBot.create(:task, title: 'Document preparation', content: 'Create a proposal.', deadline_on: '2026-12-31', priority: 'medium', status: 'not_started', user: user)
         visit task_path(task.id)
         expect(page).to have_content 'Document preparation'
         expect(page).to have_content 'Create a proposal.'
       end
     end
  end
end