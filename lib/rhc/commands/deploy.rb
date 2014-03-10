require 'rhc/commands/app'

module RHC::Commands
  class Deploy < App

    summary "Deploy a git reference or binary file of an application"
    syntax "<ref> --app NAME [--namespace NAME]"
    description <<-DESC
      By default StartApp applications prepare, distribute, and activate deployments
      on every git push. Alternatively, a user may choose to disable automatic
      deployments and use 'app deploy' and 'app deployment' commands to fully control the
      deployment lifecycle.

      Use this command to prepare, distribute and deploy manually from a git reference
      (commit id, tag or branch) or from a binary file. Check also 'app configure-app'
      to configure your application to deploy manually and set the number of deployments
      to keep in history.

      DESC
    takes_application
    argument :ref, "Git tag, branch or commit id or path to binary file to be deployed", ["--ref REF"], :optional => false
    option "--[no-]hot-deploy", "Perform hot deployment according to the specified argument rather than checking for the presence of the hot_deploy marker in the application git repo"
    option "--[no-]force-clean-build", "Perform a clean build according to the specified argument rather than checking for the presence of the force_clean_build marker in the application git repo"

    def run(ref)
      self.class.superclass.instance_method(:delete).bind(self).call ref

      0
    end

  end
end
