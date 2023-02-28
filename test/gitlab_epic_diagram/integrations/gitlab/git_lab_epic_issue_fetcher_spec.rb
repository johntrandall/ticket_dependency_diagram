require 'test_helper'
require 'vcr_helper'

describe TicketDependencyDiagram::GitLabEpicIssueFetcher do
  describe ".load_remote_data" do
    it 'loads data' do
      VCR.use_cassette(:fetch_remote_data, :match_requests_on => [:method, :uri]) do
        gitlab_remote_ids = TicketDependencyDiagram::Orchestrator::DEFAULT_GITLAB_IDS
        issue_fetcher = TicketDependencyDiagram::GitLabEpicIssueFetcher.new(gitlab_remote_ids)
        assert_equal 40, issue_fetcher.fetch_remote_data.size
      end
    end
  end
end
