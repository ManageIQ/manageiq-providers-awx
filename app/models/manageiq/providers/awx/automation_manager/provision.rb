class ManageIQ::Providers::Awx::AutomationManager::Provision < ManageIQ::Providers::AutomationManager::Provision
  include StateMachine

  TASK_DESCRIPTION = N_("AWX Job Template Provision")
end
