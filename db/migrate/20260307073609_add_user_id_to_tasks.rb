class AddUserIdToTasks < ActiveRecord::Migration[6.1]
  def change
    # The 'foreign_key: true' automatically adds the required index!
    add_reference :tasks, :user, null: false, foreign_key: true
  end
end