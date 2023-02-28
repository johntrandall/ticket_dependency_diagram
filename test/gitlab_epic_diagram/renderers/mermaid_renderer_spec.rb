require 'test_helper'
require 'vcr_helper'

describe TicketDependencyDiagram::Issue do
  describe '#perform' do
    it 'renders, basic' do
      expected_mermaid_output = <<-MERMAID_MARKDOWN
flowchart LR
  1[1: One]
  2[2: Two]
  3[3: Three]
  4[4: Four]
1-->2
1-->3
2-->4
      MERMAID_MARKDOWN

      data = [
        TicketDependencyDiagram::Issue.new(id: 1, iid: 1, title: "One", blocked_ids: [2, 3], blocked_by_ids: nil),
        TicketDependencyDiagram::Issue.new(id: 2, iid: 2, title: "Two", blocked_ids: [4], blocked_by_ids: [1]),
        TicketDependencyDiagram::Issue.new(id: 3, iid: 3, title: "Three", blocked_ids: nil, blocked_by_ids: [1]),
        TicketDependencyDiagram::Issue.new(id: 4, iid: 4, title: "Four", blocked_ids: nil, blocked_by_ids: [2]),
      ]
      TicketDependencyDiagram::IssueCollection.load_data(data)

      assert_equal expected_mermaid_output, TicketDependencyDiagram::MermaidRenderer.new(data).perform(include_gitlab_mermaid_wrapper: false, to_clipboard: true)
    end

    it 'renders, with groups and style' do
      expected_mermaid_output = <<-MERMAID_MARKDOWN
flowchart LR
  1[1: One green]
    style 1 fill:mediumaquamarine
  2[2: Two]
  subgraph g3[g3]
    3[3: Three red]
      style 3 fill:lightpink
  end
  subgraph g3[g3]
    4[4: Four]
  end
1-->2
1-->3
2-->4
      MERMAID_MARKDOWN

      data = [
        TicketDependencyDiagram::Issue.new(id: 1, iid: 1, title: "One green", blocked_ids: [2, 3], blocked_by_ids: nil),
        TicketDependencyDiagram::Issue.new(id: 2, iid: 2, title: "Two", blocked_ids: [4], blocked_by_ids: [1]),
        TicketDependencyDiagram::Issue.new(id: 3, iid: 3, title: "[g3] Three red", blocked_ids: nil, blocked_by_ids: [1]),
        TicketDependencyDiagram::Issue.new(id: 4, iid: 4, title: "[g3] Four", blocked_ids: nil, blocked_by_ids: [2]),
      ]
      TicketDependencyDiagram::IssueCollection.load_data(data)

      assert_equal expected_mermaid_output, TicketDependencyDiagram::MermaidRenderer.new(data).perform(include_gitlab_mermaid_wrapper: false, to_clipboard: true)
    end
  end
end
