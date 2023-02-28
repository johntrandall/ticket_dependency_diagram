require 'test_helper'
require 'vcr_helper'

describe TicketDependencyDiagram::Issue do
  before do
    #TODO this should be a global teardown, rather than a before block
    TicketDependencyDiagram::IssueCollection.destroy_all # faux-database clean-out
  end

  describe ".load_remote_data" do
    it 'loads data' do
      VCR.use_cassette(:fetch_remote_data, :match_requests_on => [:method, :uri]) do
        assert_equal TicketDependencyDiagram::IssueCollection.count, 0
        TicketDependencyDiagram::IssueCollection.load_remote_data(TicketDependencyDiagram::Orchestrator::DEFAULT_GITLAB_IDS)
        assert_equal TicketDependencyDiagram::IssueCollection.count, 40
      end
    end
  end
end
