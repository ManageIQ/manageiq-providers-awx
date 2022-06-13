class ManageIQ::Providers::Awx::AutomationManager::RefreshWorker < MiqEmsRefreshWorker
  require_nested :Runner

  def self.settings_name
    :ems_refresh_worker_awx_automation
  end
end
