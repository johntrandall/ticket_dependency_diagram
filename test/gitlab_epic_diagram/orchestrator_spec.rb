require 'test_helper'
require 'vcr_helper'

describe TicketDependencyDiagram::Orchestrator do

  describe "#perform" do
    it '#calls the things' do
      VCR.use_cassette(cassette_location, :match_requests_on => [:method, :uri]) do
        fake_issues = [TicketDependencyDiagram::Issue.new(id: 1, iid: 2)]
        TicketDependencyDiagram::IssueCollection.stubs(:load_remote_data).returns(fake_issues)
        TicketDependencyDiagram::MermaidRenderer.stubs(:new).returns(mock(perform: 'fake mermaid'))
        TicketDependencyDiagram::GitLabEpicDescriptionUpdater.stubs(:append_mermaid_diagram_to_epic_description).with('fake mermaid').returns(nil)

        TicketDependencyDiagram::Orchestrator.new(gitlab_remote_ids: TicketDependencyDiagram::Orchestrator::DEFAULT_GITLAB_IDS).perform
      end
    end

    it "end to end, to clipboard" do
      VCR.use_cassette(cassette_location, :match_requests_on => [:method, :uri]) do
        TicketDependencyDiagram::Orchestrator.new(gitlab_remote_ids: TicketDependencyDiagram::Orchestrator::DEFAULT_GITLAB_IDS).perform(clipboard: true, skip_upload: true)
      end
    end
  end
end
