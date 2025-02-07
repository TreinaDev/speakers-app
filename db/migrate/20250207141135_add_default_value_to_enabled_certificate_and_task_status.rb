class AddDefaultValueToEnabledCertificateAndTaskStatus < ActiveRecord::Migration[8.0]
  def change
    change_column_default(:participant_tasks, :task_status, false)
    change_column_default(:participant_records, :enabled_certificate, false)
  end
end
