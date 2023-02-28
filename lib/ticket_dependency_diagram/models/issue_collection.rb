# frozen_string_literal: true

class TicketDependencyDiagram::IssueCollection
  def self.load_data(issues_data = nil)
    @@all_data = issues_data
  end

  def self.load_remote_data(gitlab_remote_ids)
    issues = TicketDependencyDiagram::GitLabEpicIssueFetcher.new(gitlab_remote_ids).issues
    @@all_data = issues
    @@all_data
  end

  def self.all
    @@all_data ||= []
  end

  def self.open
    all.select { |issue_datum| issue_datum.state == :opened }
  end

  def self.count
    all.size
  end

  def self.destroy_all
    @@all_data = []
  end

  def self.find_all(ids)
    all.select { |issue_datum| ids&.include? issue_datum.id }
  end

  def self.find(id)
    all.select { |issue_datum| issue_datum.id == id }.first
  end
end
