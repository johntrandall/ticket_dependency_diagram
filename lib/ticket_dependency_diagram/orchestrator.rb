# require_relative 'git_lab_data_fetcher'
class TicketDependencyDiagram::Orchestrator

  DEFAULT_GITLAB_IDS = {
    group_id: 3155809, # JK_LABS
    project_id: 7646937,
    epic_id: 147 # AWS Epic
  }

  def initialize(gitlab_remote_ids: {}, data: :load_remote)
    raise "gitlab remote ids missing" unless [:group_id, :project_id, :epic_id].all? { |key| gitlab_remote_ids.keys.include?(key) }

    @data = data

    group_id = gitlab_remote_ids[:group_id] || DEFAULT_GITLAB_IDS[:group_id]
    project_id = gitlab_remote_ids[:project_id] || DEFAULT_GITLAB_IDS[:project_id]
    epic_id = gitlab_remote_ids[:epic_id] || DEFAULT_GITLAB_IDS[:epic_id]
    @gitlab_remote_ids = {
      group_id: group_id,
      project_id: project_id,
      epic_id: epic_id
    }
  end

  def perform(load_remote_data: true, clipboard: true, include_closed_issues: false, skip_upload: false, include_gitlab_mermaid_wrapper: true)
    if @data == :load_remote
      @data = TicketDependencyDiagram::IssueCollection.load_remote_data(@gitlab_remote_ids)
    else
      @data = data
    end

    issues_to_render = include_closed_issues ? @data : @data.select { |issue_datum| issue_datum.state == :opened }

    mermaid_markdown = TicketDependencyDiagram::MermaidRenderer.new(issues_to_render).perform(include_gitlab_mermaid_wrapper: include_gitlab_mermaid_wrapper)
    pbcopy(mermaid_markdown) if clipboard
    TicketDependencyDiagram::GitLabEpicDescriptionUpdater.new.append_mermaid_diagram_to_epic_description(gitlab_remote_ids: @gitlab_remote_ids, mermaid_markdown: mermaid_markdown) unless skip_upload
  end

  private

  def pbcopy(input)
    # works on OSX
    str = input.to_s
    IO.popen('pbcopy', 'w') { |f| f << str }
    str
  end

end