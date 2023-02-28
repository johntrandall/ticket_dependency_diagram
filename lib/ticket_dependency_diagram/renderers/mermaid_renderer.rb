require 'active_support/all' # for truncate
class TicketDependencyDiagram::MermaidRenderer

  RED_WORDS = ["red", "risk"]
  YELLOW_WORDS = ["yellow", "unknown", "spike"]
  GREEN_WORDS = ["green", "value", "GA", "release", "public", "demo"]

  SUBGRAPH_IDENTIFIER_REGEX = /\[(.*)\]/
  SUBGRAPH_IDENTIFIER_REMOVAL_REGEX = / ?\[.*\]/
  TRUNCATION_LIMIT = 70

  def initialize(data)
    @data = data
    @mermaid_string = ""
  end

  def perform(data = @data, to_clipboard: false, include_gitlab_mermaid_wrapper: true, render_subgroups: true)
    @render_subgroups = render_subgroups
    mermaid_markdown = ""
    mermaid_markdown += "```mermaid\n" if include_gitlab_mermaid_wrapper
    mermaid_markdown += render_data(data, indent_level: (include_gitlab_mermaid_wrapper ? 1 : 0))
    mermaid_markdown += "````\n" if include_gitlab_mermaid_wrapper
    pbcopy(mermaid_markdown) if to_clipboard
    mermaid_markdown
  end

  def render_data(data = @data, indent_level:)
    top_indent_level = indent_level

    @mermaid_string += indent_space_string(indent_level) + "flowchart LR\n"
    indent_level += 1

    data.each do |issue_datum|
      render_issue_data(indent_level, issue_datum)
    end

    data.each do |issue_datum|
      issue_datum.blocked_issues.each do |blocked_issue_datum|
        next unless issue_datum.in?(data) && blocked_issue_datum.in?(data)
        @mermaid_string += indent_space_string(top_indent_level) + "#{issue_datum.iid}-->#{blocked_issue_datum.iid}\n"
      end
    end
    @mermaid_string
  end

  private

  def render_issue_data(indent_level, issue_datum)
    puts "\n"
    puts "rendering #{issue_datum.id}, #{issue_datum.title}"

    if bracket_designated_subgroup(issue_datum) && @render_subgroups
      render_subgraph_start_v2(issue_datum, indent_level: indent_level)
      render_issue_box(issue_datum, indent_level: indent_level + 1)
      render_subgraph_end(issue_datum, indent_level: indent_level)
    else
      render_issue_box(issue_datum, indent_level: indent_level)
    end
  end

  def render_issue_box(issue_datum, indent_level:)
    @mermaid_string += indent_space_string(indent_level) + "#{issue_datum.iid}[#{mermaid_display_title(issue_datum)}]\n"
    indent_level += 1
    @mermaid_string += indent_space_string(indent_level) + "style #{issue_datum.iid} fill:mediumaquamarine\n" if title_includes_keyword_from(GREEN_WORDS, issue_datum)
    @mermaid_string += indent_space_string(indent_level) + "style #{issue_datum.iid} fill:lightpink\n" if title_includes_keyword_from(RED_WORDS, issue_datum)
    @mermaid_string += indent_space_string(indent_level) + "style #{issue_datum.iid} fill:yellow\n" if title_includes_keyword_from(YELLOW_WORDS, issue_datum)
    @mermaid_string += indent_space_string(indent_level) + "style #{issue_datum.iid} fill:grey\n" if issue_datum.state == :closed
  end

  def mermaid_display_title(issue_datum)
    identifier_without_group = issue_datum.identifier.remove(SUBGRAPH_IDENTIFIER_REMOVAL_REGEX) if @render_subgroups
    mermaid_sanitize(identifier_without_group).truncate(TRUNCATION_LIMIT)
  end

  def render_subgraph_start_v2(issue_datum, indent_level:)
    designator = bracket_designated_subgroup(issue_datum)
    display_name = mermaid_sanitize(designator)
    subgroup_identifier = mermaid_sanitize(designator).gsub(" ", "_")
    @mermaid_string += indent_space_string(indent_level) + "subgraph #{subgroup_identifier}[#{display_name}]\n"
  end

  def render_subgraph_end(issue_datum, indent_level:)
    @mermaid_string += indent_space_string(indent_level) + "end\n"
  end

  def title_includes_keyword_from(word_list, issue_datum)
    word_list.any? { |word| issue_datum.title.downcase.include? word }
  end

  def bracket_designated_subgroup(issue)
    SUBGRAPH_IDENTIFIER_REGEX.match(issue.title)&.[](1)
  end

  def indent_space_string(indent_level)
    Array.new(indent_level, "  ").join
  end

  def pbcopy(input)
    # works on OSX
    str = input.to_s
    IO.popen('pbcopy', 'w') { |f| f << str }
    str
  end

  MERMAID_SPECIAL_CHARS_BRACKETS = ["[",
                                    "]",
                                    "{",
                                    "}",
                                    "(",
                                    ")"]

  MERMAID_SPECIAL_CHARS_QUOTES = ["’", # tick mark
                                  "\"", # straight double quote
                                  "“", # open quote
                                  "”", # close quote
  ]

  def mermaid_sanitize(title)
    safe_title = title
    TicketDependencyDiagram::MermaidRenderer::MERMAID_SPECIAL_CHARS_BRACKETS.each do |special_char|
      safe_title = safe_title.gsub(special_char, "_")
    end
    TicketDependencyDiagram::MermaidRenderer::MERMAID_SPECIAL_CHARS_QUOTES.each do |special_char|
      safe_title = safe_title.gsub(special_char, "'")
    end
    safe_title
  end
end
