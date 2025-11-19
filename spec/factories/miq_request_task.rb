FactoryBot.define do
  factory :miq_provision_awx, :parent => :miq_provision, :class => "ManageIQ::Providers::Awx::AutomationManager::Provision"
end
