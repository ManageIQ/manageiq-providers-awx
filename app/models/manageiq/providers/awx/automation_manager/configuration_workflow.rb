class ManageIQ::Providers::Awx::AutomationManager::ConfigurationWorkflow < ManageIQ::Providers::ExternalAutomationManager::ConfigurationWorkflow
  include ProviderObjectMixin

  def run_with_miq_job(options, userid = nil)
    options[:name] = "Workflow Template: #{name}"
    options[:ansible_template_id] = id
    options[:userid] = userid || 'system'
    miq_job = ManageIQ::Providers::Awx::AutomationManager::TemplateRunner.create_job(options)
    miq_job.signal(:start)
    miq_job.miq_task.id
  end

  def self.stack_type
    "WorkflowJob"
  end

  def supports_limit?
    false
  end

  def self.display_name(number = 1)
    n_('Workflow Template (%{provider_description})', 'Workflow Templates (%{provider_description})', number) % {:provider_description => module_parent.description}
  end

  def self.provider_collection(manager)
    manager.with_provider_connection do |connection|
      connection.api.workflow_job_templates
    end
  end

  def run(vars = {})
    options = vars.merge(merge_extra_vars(vars[:extra_vars]))

    with_provider_object do |jt|
      jt.launch(options)
    end
  end

  def merge_extra_vars(external)
    {:extra_vars => variables.to_h.merge(external.to_h).to_json}
  end

  def provider_object(connection = nil)
    (connection || connection_source.connect).api.workflow_job_templates.find(manager_ref)
  end

  FRIENDLY_NAME = 'AWX Workflow Job Template'.freeze
end
