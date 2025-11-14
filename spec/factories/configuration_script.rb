FactoryBot.define do
  factory :awx_configuration_script,
          :class  => "ManageIQ::Providers::Awx::AutomationManager::ConfigurationScript",
          :parent => :configuration_script
  factory :awx_configuration_workflow,
          :class  => "ManageIQ::Providers::Awx::AutomationManager::ConfigurationWorkflow",
          :parent => :configuration_script
end
