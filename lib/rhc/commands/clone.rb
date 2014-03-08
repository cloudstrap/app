require 'rhc/commands/git_clone'

module RHC::Commands
  class Clone < GitClone
    summary "Clone and configure an application's repository locally"
    description "This is a convenience wrapper for 'git clone' with the added",
                "benefit of adding configuration data such as the application's",
                "UUID to the local repository.  It also automatically",
                "figures out the Git url from the application name so you don't",
                "have to look it up."
    syntax "<app> [--namespace NAME]"
    takes_application :argument => true
    option ["-r", "--repo dir"], "Path to the Git repository (defaults to ./$app_name)"
    # alias_action 'app git-clone', :deprecated => true, :root_command => true
    # TODO: Implement default values for arguments once ffranz has added context arguments
    # argument :directory, "The name of a new directory to clone into", [], :default => nil
    def run(app_name)

      if url? app_name
        if app = clonable_url?(app_name)
          app_name = options.app = app[:name]
          options.namespace = app[:domain]
        else
          warn "URL is invalid. To clone app your url must be something like this: http://appname-domain.startappcloud.com/"
          return 1
        end
      end

      super app_name
    end

    private

    def clonable_url?(app_name)
      if startapp_url? app_name
        app_name = clean_url(app_name)
        app = extract_name_and_domain(app_name)

        app
      else
        false
      end
    end

    def url?(candidate)
      !!(/http|\./.match(candidate))
    end

    def startapp_url?(candidate)
      !!(/[a-zA-Z0-9]+-[a-zA-Z0-9]+\.startappcloud\./.match(candidate))
    end

    def clean_url(url)
      url.dup.gsub!(/http(s?):\/\/|\//,'')
    end

    def extract_name_and_domain(url)
      result = {}
      name_and_domain = /([a-zA-Z0-9]+)-([a-zA-Z0-9]+)/.match(url)
      result[:name], result[:domain] = name_and_domain[1], name_and_domain[2]

      result
    end

  end
end
