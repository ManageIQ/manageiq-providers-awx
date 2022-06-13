FactoryBot.define do
  factory :awx_configuration_script,
          :class  => "ManageIQ::Providers::Awx::AutomationManager::ConfigurationScript",
          :parent => :configuration_script
end
