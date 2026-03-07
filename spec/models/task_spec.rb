require 'rails_helper'

RSpec.describe 'Task model function', type: :model do
  describe 'Search function' do
    # Creating the 3 specific test tasks the assignment requested
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', deadline_on: '2022-02-18', priority: 'medium', status: 'not_started') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', deadline_on: '2022-02-17', priority: 'high', status: 'in_progress') }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', deadline_on: '2022-02-16', priority: 'low', status: 'completed') }

    context 'Title is performed by scope method' do
      it "Tasks containing search words are narrowed down." do
        # We expect only first_task to be returned when searching for "first"
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
      end
    end

    context 'When the status is searched with the scope method' do
      it "Tasks that exactly match the status are narrowed down" do
        # We expect only first_task to be returned when searching for "not_started"
        expect(Task.search_status('not_started')).to include(first_task)
        expect(Task.search_status('not_started')).not_to include(second_task)
        expect(Task.search_status('not_started')).not_to include(third_task)
        expect(Task.search_status('not_started').count).to eq 1
      end
    end

    context 'When performing fuzzy search and status search Title' do
      it "Refine your search to tasks that contain the search word Title and match the status exactly." do
        # We chain the scopes together to test both conditions at once
        expect(Task.search_title('first').search_status('not_started')).to include(first_task)
        expect(Task.search_title('first').search_status('not_started')).not_to include(second_task)
        expect(Task.search_title('first').search_status('not_started')).not_to include(third_task)
        expect(Task.search_title('first').search_status('not_started').count).to eq 1
      end
    end
  end
end