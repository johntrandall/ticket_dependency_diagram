class TicketDependencyDiagram
  def self.hello_world(args)
    puts "Hello world! #{args}"
  end

  def self.perform(...)
    Orchestrator.new(...).perform
  end
end

require 'dotenv'
Dotenv.load

require './lib/ticket_dependency_diagram/orchestrator'
require './lib/ticket_dependency_diagram/models/issue'
require './lib/ticket_dependency_diagram/models/issue_collection'
require './lib/ticket_dependency_diagram/integrations/gitlab/git_lab_gateway'
require './lib/ticket_dependency_diagram/integrations/gitlab/git_lab_epic_issue_fetcher'
require './lib/ticket_dependency_diagram/integrations/gitlab/git_lab_epic_description_updater'
require './lib/ticket_dependency_diagram/renderers/mermaid_renderer'
# require 'ticket_dependency_diagram/renderers/graphviz_renderer'

