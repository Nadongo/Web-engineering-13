require 'rails_helper'

RSpec.describe 'Label management function', type: :system do
  let(:user) { FactoryBot.create(:user) }
  
  before do
    # Ensure the user is logged in before testing label features
    visit new_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  describe 'Registration function' do
    context 'When a label is registered' do
      it 'Registered labels are displayed.' do
        visit new_label_path
        # Using the exact HTML ID requested in the requirements
        fill_in 'labels', with: 'New Test Label'
        click_button 'register'
        
        expect(page).to have_content 'New Test Label'
      end
    end
  end

  describe 'List display function' do
    context 'When transitioning to the list screen' do
      it 'A list of registered labels is displayed.' do
        FactoryBot.create(:label, name: 'Sample Label', user: user)
        
        visit labels_path
        expect(page).to have_content 'Sample Label'
      end
    end
  end
end