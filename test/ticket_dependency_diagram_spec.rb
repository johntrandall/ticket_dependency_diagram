require 'test_helper'

describe TicketDependencyDiagram do

  it '#minitest works' do
    assert true, true
  end

  describe "#dot_it" do
    it '#calls Orchestrator' do
      args = [:x, :y, :z]
      TicketDependencyDiagram::Orchestrator.expects(:new).with(args).returns(mock_orchestrator = mock())
      mock_orchestrator.expects(:perform)

      TicketDependencyDiagram.perform(args)
    end
  end

  describe "#live integration test" do
    it '#runs against live data' do
      # skip()


      TicketDependencyDiagram.perform
    end
  end


end
