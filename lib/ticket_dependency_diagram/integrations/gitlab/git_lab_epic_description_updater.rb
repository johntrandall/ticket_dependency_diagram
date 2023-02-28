require 'gitlab'

class TicketDependencyDiagram::GitLabEpicDescriptionUpdater
  def initialize
    @gateway = TicketDependencyDiagram::GitLabGateway.new
    @client = @gateway.client
  end

  START_MARKER_FOR_GITLAB_TITLE =
    END_MARKER_FOR_GITLAB =

      def append_mermaid_diagram_to_epic_description(gitlab_remote_ids:, mermaid_markdown:)
        group = @client.group(gitlab_remote_ids[:group_id])
        project = @client.project(gitlab_remote_ids[:project_id])
        epic = @client.epic(group.id, gitlab_remote_ids[:epic_id])

        insert = "### Issue Relationships Diagram"
        insert += "\n"
        insert += "_Rendered by the ticket_dependency_diagram gem, last rendered: #{Time.now}_"
        insert += "\n"
        insert += mermaid_markdown
        insert += "\n"
        insert += "issue relationships diagram end - do not edit this line"

        puts "\n\nOriginal description:"
        puts epic.description

        text_before_start_marker = epic.description.scan(/((.|\n)*)^.*Issue Relationships Diagram/)
        raise if text_before_start_marker.size > 1
        text_before_start_marker = text_before_start_marker&.first&.first

        text_after_end_marker = epic.description.scan(/issue relationships diagram end - do not edit this line.*\n((.|\n)*)/)
        raise if text_after_end_marker.size > 1
        text_after_end_marker = text_after_end_marker&.first&.first

        new_description = "#{(text_before_start_marker || epic.description)}\n#{insert}\n#{text_after_end_marker}\n"

        puts "\n\nNew description:"
        puts new_description
        puts "\n\nInserting graph into #{group['name']} : Epic \##{epic['id']} (#{epic['title']}) description..."

        @client.edit_epic(group.id, epic.iid, options = { description: new_description })
      end
end
