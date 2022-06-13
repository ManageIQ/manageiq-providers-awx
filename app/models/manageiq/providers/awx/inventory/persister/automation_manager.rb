class ManageIQ::Providers::Awx::Inventory::Persister::AutomationManager < ManageIQ::Providers::Awx::Inventory::Persister
  include ManageIQ::Providers::Awx::Inventory::Persister::Definitions::AutomationCollections

  def initialize_inventory_collections
    initialize_automation_inventory_collections
  end
end
