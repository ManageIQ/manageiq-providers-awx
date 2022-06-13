class ManageIQ::Providers::Awx::Inventory::Collector < ManageIQ::Providers::Inventory::Collector
  require_nested :AutomationManager
  require_nested :TargetCollection
end
