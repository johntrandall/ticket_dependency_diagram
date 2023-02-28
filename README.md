# ticket dependency diagram

## What?

* Pulls info from a Gitlab epic
* crawls through the issues to discover all of the blocking/blocked-by dependencies between stories
* Renders a ~~GraphViz~~ Mermaid diagram
* Pushes the diagram back up to the GitLab epic

## Setup

~~install `gem install ticket_dependency_diagram`~~

for now, to install just clone this repo

find the install directory `which ticket_dependency_diagram`

copy env.example to .env and add your gitlab token 

to run: `ticket_dependency_diagram`




## WIP - State of affairs

* Test suite is not robust
* Tests are broken
  * The VCR cassettes seem to rot for no reason. Maybe it's time based. TimeCop?
  * I haven't been able to find a mermaid syntax checker
* Running Orchestrator end-to-end clipboard test dumps Mermaid into the clipboard on OSX, where it can be pasted into a mermaid renderer to check syntax.
  * try pasting into https://mermaid.live/ or https://apps.apple.com/us/app/mermaideditor/id1581312955


## TODO
* Try to make it render following the order of the epic from top to bottom.
* Namespacing is probably unconventional/wrong
* Gemspec may not be right