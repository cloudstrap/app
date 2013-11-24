require 'rhc/commands/app'

module RHC::Commands
  class Create < App

    summary "Create an application"
    description <<-DESC
      Create an application. Every StartApp application must have one
      web cartridge which serves web requests, and can have a number of
      other cartridges which provide capabilities like databases,
      scheduled jobs, or continuous integration.

      You can see a list of all valid cartridge types by running
      'app cartridge list'. StartApp also supports downloading cartridges -
      pass a URL in place of the cartridge name and we'll download
      and install that cartridge into your app.  Keep in mind that
      these cartridges receive no security updates.  Note that not
      all StartAPp servers allow downloaded cartridges.

      When your application is created, a URL combining the name of
      your app and the name of your domain will be registered in DNS.
      A copy of the code for your application will be checked out locally
      into a folder with the same name as your application.  Note that
      different types of applications may require different folder
      structures - check the README provided with the cartridge if
      you have questions.

      StartApp runs the components of your application on small virtual
      servers called "gears".  Each account or plan is limited to a number
      of gears which you can use across multiple applications.  Some
      accounts or plans provide access to gears with more memory or more
      CPU.  Run 'app account' to see the number and sizes of gears available
      to you.  When creating an application the --gear-size parameter
      may be specified to change the gears used.

      DESC
    syntax "<name> <cartridge> [... <cartridge>] [... VARIABLE=VALUE] [-n namespace]"
    option ["-n", "--namespace NAME"], "Namespace for the application"
    option ["-g", "--gear-size SIZE"], "Gear size controls how much memory and CPU your cartridges can use."
    option ["-s", "--scaling"], "Enable scaling for the web cartridge."
    option ["-r", "--repo DIR"], "Path to the Git repository (defaults to ./$app_name)"
    option ["-e", "--env VARIABLE=VALUE"], "Environment variable(s) to be set on this app, or path to a file containing environment variables", :type => :list
    option ["--from-code URL"], "URL to a Git repository that will become the initial contents of the application"
    option ["--[no-]git"], "Skip creating the local Git repository."
    option ["--[no-]dns"], "Skip waiting for the application DNS name to resolve. Must be used in combination with --no-git"
    option ['--no-keys'], "Skip checking SSH keys during app creation", :hide => true
    option ["--enable-jenkins [NAME]"], "Enable Jenkins builds for this application (will create a Jenkins application if not already available). The default name will be 'jenkins' if not specified."
    argument :name, "Name for your application", ["-a", "--app NAME"], :optional => true
    argument :cartridges, "The web framework this application should use", ["-t", "--type CARTRIDGE"], :optional => true, :type => :list
    def run(name, cartridges)
      self.class.superclass.instance_method(:create).bind(self).call name, cartridges

      0
    end

  end
end
