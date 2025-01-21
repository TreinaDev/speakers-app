class ChangeDefaultValueToEventTaskEnum < ActiveRecord::Migration[8.0]
  def up
    change_column_default :event_tasks, :certificate_requirement, 0
  end

  def down
    change_column_default :event_tasks, :certificate_requirement
  end
end
