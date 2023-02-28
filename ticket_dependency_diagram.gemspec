Gem::Specification.new do |s|
  s.name        = "GitLabEpicDiagram"
  s.version     = "0.0.0"
  s.summary     = "wip"
  s.description = "wip"
  s.authors     = ["John Randall"]
  s.email       = "john@johnrandall.com"
  s.files       = ["lib/ticket_dependency_diagram.rb",
                   ]
  s.executables << "ticket_dependency_diagram"
  s.homepage    =
    "https://opslevel.com"
  s.license       = "MIT"

  s.add_runtime_dependency "gitlab", "~>4.0"
  s.add_runtime_dependency "activesupport", "~>7.0"
  s.add_runtime_dependency "dotenv", "~>2.0"

  s.add_development_dependency "minitest", "~>5.0"
  s.add_development_dependency "mocha", "~>1.0"
  s.add_development_dependency "vcr", "~>6.0"
  s.add_development_dependency "webmock", "~>3.0" # for VCR
  s.add_development_dependency "byebug"
end