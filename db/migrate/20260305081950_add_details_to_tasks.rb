class AddDetailsToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :deadline_on, :date, null: false
    add_column :tasks, :priority, :integer, null: false
    add_column :tasks, :status, :integer, null: false
    
    # Adding the required index for faster searching
    add_index :tasks, :status
  end
end