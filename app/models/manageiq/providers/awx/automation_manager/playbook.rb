class ManageIQ::Providers::Awx::AutomationManager::Playbook <
  ManageIQ::Providers::ExternalAutomationManager::ConfigurationScriptPayload

  has_many :jobs, :class_name => 'OrchestrationStack', :foreign_key => :configuration_script_base_id

  def self.display_name(number = 1)
    n_('Playbook (%{provider_description})', 'Playbooks (%{provider_description})', number) % {:provider_description => module_parent.description}
  end
end
