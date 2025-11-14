module ManageIQ::Providers::Awx::AutomationManager::Provision::StateMachine
  def run_provision
    signal :provision
  end

  def provision
    stack_class = "#{source.class.module_parent}::#{source.class.stack_type}".constantize
    stack       = stack_class.create_stack(source)

    phase_context[:stack_id] = stack.id
    save!

    signal :check_provisioned
  end

  def check_provisioned
    if running?
      requeue_phase
    else
      signal :post_provision
    end
  end

  def post_provision
    if succeeded?
      signal :mark_as_completed
    else
      abort_job("Failed to provision stack", "error")
    end
  end

  def running?
    !stack.raw_status.completed?
  end

  def succeeded?
    stack.raw_status.succeeded?
  end

  def mark_as_completed
    update_and_notify_parent(:state => "finished", :message => "Stack provision is complete")
    signal :finish
  end

  def finish
    mark_execution_servers
  end

  def stack_klass
    @stack_klass ||= "#{source.class.module_parent}::#{source.class.stack_type}".constantize
  end

  def stack
    @stack ||= stack_klass.find(phase_context[:stack_id])
  end
end
