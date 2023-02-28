class TicketDependencyDiagram::Issue
  attr_accessor :id, :iid, :title, :blocked_ids, :blocked_by_ids, :state
  attr_writer :processed
  attr_reader :processed

  def initialize(id:, iid:, state: :opened, relative_position: nil, weight: nil, labels: nil, title: nil, blocked_ids: nil, blocked_by_ids: nil)
    @id = id
    @iid = iid
    @state = state
    @title = title
    @labels = labels
    @relative_position = relative_position
    @weight = weight
    @blocked_ids = blocked_ids
    @blocked_by_ids = blocked_by_ids
    @processed = false
  end

  def blocked_issues
    TicketDependencyDiagram::IssueCollection.find_all(blocked_ids)
  end

  def identifier
    "#{iid}: #{title}"
  end
end
