class ManageIQ::Providers::Awx::AutomationManager::ProvisionWorkflow < ManageIQ::Providers::AutomationManager::ProvisionWorkflow
  def dialog_name_from_automate(message = 'get_dialog_name', extra_attrs = {})
    extra_attrs['platform'] ||= 'awx'
    super
  end

  def allowed_configuration_scripts(*args)
    job_templates = self.class.module_parent::ConfigurationScript.all.map do |cs|
      build_ci_hash_struct(cs, %w[name description manager_name])
    end

    workflow_job_templates = self.class.module_parent::ConfigurationWorkflow.all.map do |cs|
      build_ci_hash_struct(cs, %w[name description manager_name])
    end

    job_templates + workflow_job_templates
  end
end
