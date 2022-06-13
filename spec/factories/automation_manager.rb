FactoryBot.define do
  factory :automation_manager_awx,
  :aliases => ["manageiq/providers/awx/automation_manager"],
  :class   => "ManageIQ::Providers::Awx::AutomationManager",
  :parent  => :automation_manager do
    provider :factory => :provider_awx
  end
end
