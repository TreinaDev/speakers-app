class RemoveStatusAndChangeIsMandatoryName < ActiveRecord::Migration[8.0]
  def change
    remove_column :event_tasks, :status, :integer
    rename_column :event_tasks, :is_mandatory, :certificate_requirement
  end
end
