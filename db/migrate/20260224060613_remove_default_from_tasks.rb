class RemoveDefaultFromTasks < ActiveRecord::Migration[6.1]
  def change
    change_column_default :tasks, :deadline_on, from: -> { 'CURRENT_DATE' }, to: nil
    change_column_default :tasks, :priority, from: 0, to: nil
    change_column_default :tasks, :status, from: 0, to: nil
  end
end
