require 'gitlab'

class TicketDependencyDiagram::GitLabEpicIssueFetcher
  def initialize(gitlab_remote_ids)
    @group_id = gitlab_remote_ids[:group_id]
    @project_id = gitlab_remote_ids[:project_id]
    @epic_id = gitlab_remote_ids[:epic_id]
    @gateway = TicketDependencyDiagram::GitLabGateway.new
    @client = @gateway.client
  end

  def issues
    @issues ||= self.fetch_remote_data
  end

  def fetch_remote_data
    group = @client.group(@group_id)
    project = @client.project(@project_id)
    epic = @client.epic(group.id, @epic_id)
    epic_issues = @client.epic_issues(group.id, @epic_id, { per_page: 100 })

    puts "\ngetting data for #{group['name']}: Epic \##{epic['iid']} (#{epic['title']})..."
    @issues = epic_issues.map do |fetched_issue|
      puts "getting data for issue #{fetched_issue.iid}"
      issue_links = Gitlab.issue_links(@project_id, fetched_issue.iid, { per_page: 100 })
      issues_blocked = issue_links.select { |issue_link| issue_link.link_type == "blocks" }
      issues_blocked_by = issue_links.select { |issue_link| issue_link.link_type == "is blocked by" }
      TicketDependencyDiagram::Issue.new(id: fetched_issue.id,
                                         iid: fetched_issue.iid,
                                         title: fetched_issue.title,
                                         state: fetched_issue.state.to_sym,
                                         weight: fetched_issue.weight.to_i,
                                         relative_position: fetched_issue.relative_position,
                                         labels: fetched_issue.labels,
                                         blocked_ids: issues_blocked.map(&:id),
                                         blocked_by_ids: issues_blocked_by.map(&:id)
      )
    end
  end
end