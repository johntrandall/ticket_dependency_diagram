require 'gitlab'

class TicketDependencyDiagram::GitLabGateway
  GITLAB_TOKEN = ENV["GITLAB_TOKEN"]

  def initialize
    raise "Gitlab token missing from ENV" unless GITLAB_TOKEN

    Gitlab.configure do |config|
      config.endpoint = 'https://gitlab.com/api/v4' # API endpoint URL, default: ENV['GITLAB_API_ENDPOINT'] and falls back to ENV['CI_API_V4_URL']
      config.private_token = GITLAB_TOKEN # user's private token or OAuth2 access token, default: ENV['GITLAB_API_PRIVATE_TOKEN']
      # Optional
      # config.user_agent   = 'Custom User Agent'          # user agent, default: 'Gitlab Ruby Gem [version]'
      # config.sudo         = 'user'                       # username for sudo mode, default: nil
    end
  end

  def client
    Gitlab
  end


end