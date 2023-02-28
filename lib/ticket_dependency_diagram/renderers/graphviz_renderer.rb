require 'ruby-graphviz' #TODO why doesn't bundler handle this?

class GraphvizRenderer
  def self.perform(data = Issue.all, filename = "hello_world")
    raise "WIP, this should probably be delted in favor of mermaid"

    graph = ::GraphViz.new(name: "GitLab Epic Dependencies Graph")

    data.each do |issue_datum|
      puts "\n"
      puts "rendering #{issue_datum.id}, #{issue_datum.title}"

      node = graph.add_node(issue_datum.identifier)
      node.shape = "rectangle"

      if (issue_datum.title.downcase.include?("gui") || issue_datum.title.downcase.include?("value") || issue_datum.title.include?("GA") || issue_datum.title.downcase.include?("release"))
        node.color = "green"
      end

      if issue_datum.title.downcase.include? "risk"
        node.color = "red"
      end
    end

    data.each do |issue_datum|
      issue_datum.blocked_issues.each do |blocked_issue_datum|
        blocker_node = graph.get_node(issue_datum.identifier)
        blocked_node = graph.get_node(blocked_issue_datum.identifier)
        graph.add_edges(blocker_node, blocked_node)
      end
    end

    graph.output(png: "#{filename}.png")
  end
end