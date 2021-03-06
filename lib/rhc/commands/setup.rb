require 'rhc/commands/base'
require 'rhc/wizard'
require 'rhc/config'

module RHC::Commands
  class Setup < Base
    suppress_wizard

    summary "Connects to StartApp and sets up your keys and domain"
    description <<-DESC
      Connects to an StartApp server to get you started. Will help you
      configure your SSH keys, set up a domain, and check for any potential
      problems with Git or SSH.

      Any options you pass to the setup command will be stored in a
      .openshift/express.conf file in your home directory. If you run
      setup at a later time, any previous configuration will be reused.

      Pass the --clean option to ignore your saved configuration and only
      use options you pass on the command line. Pass --config FILE to use
      default values from another config (the values will still be written
      to .startapp/express.conf).

      If the server supports authorization tokens, you may pass the
      --create-token option to instruct the wizard to generate a key for you.

      If you would like to enable tab-completion in Bash shells, pass
      --autocomplete for more information.
      DESC
    option ["--server NAME"], "Hostname of an OpenShift server", :default => :server_context, :required => true
    option ['--clean'], "Ignore any saved configuration options"
    option ['--[no-]create-token'], "Create an authorization token for this server"
    option ['--autocomplete'], "Instructions for enabling tab-completion"
    def run
      if options.autocomplete
        src = File.join(File.join(Gem.loaded_specs['startapp'].full_gem_path, "autocomplete"), "rhc_bash")
        dest = File.join(RHC::Config.home_conf_dir, "bash_autocomplete")

        FileUtils.mkdir_p(RHC::Config.home_conf_dir)
        FileUtils.cp(src, dest)

        say <<-LINE.strip_heredoc
          To enable tab-completion for `app` under Bash shells, add the following command to
          your .bashrc or .bash_profile file:

            . #{dest}

          Save your shell and then restart. Type "app" and then hit the TAB key twice to
          trigger completion of your command.

          Tab-completion is not available in the Windows terminal.
          LINE
        return 0
      end

      raise OptionParser::InvalidOption, "Setup can not be run with the --noprompt option" if options.noprompt
      RHC::RerunWizard.new(config, options).run ?  0 : 1
    end
  end
end
