class ManageIQ::Providers::Awx::Inventory < ManageIQ::Providers::Inventory
  def self.default_manager_name
    "AutomationManager"
  end

  def self.parser_classes_for(ems, target)
    case target
    when InventoryRefresh::TargetCollection
      [ManageIQ::Providers::Awx::Inventory::Parser::AutomationManager]
    else
      super
    end
  end
end
