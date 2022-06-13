class ManageIQ::Providers::Awx::AutomationManager::EventCatcher < ManageIQ::Providers::BaseManager::EventCatcher
  require_nested :Runner
end
