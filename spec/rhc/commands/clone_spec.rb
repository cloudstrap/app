require 'spec_helper'
require 'rest_spec_helper'
require 'rhc/commands/clone'

describe RHC::Commands::Clone do
  before{ user_config }
  let!(:rest_client){ MockRestClient.new }

  describe 'run' do

    context 'clone invalid url' do
      let(:arguments) { ['clone','http://someivalidurl.com'] }

      it { run_output.should match(/URL is invalid. To clone app your url must be something/)  }
    end

    context 'with valid url and no domains' do
      let(:arguments) { ['clone','http://myapp-mydomain.startappcloud.com'] }

      it { expect { run }.to exit_with_code(127) }
      it { run_output.should match(/Domain *mydomain* not found/) }
    end

    context 'with valid url and domain' do
      let(:arguments) { ['clone','http://myapp-myfirsrdomain.startappcloud.com'] }
      let!(:domain){ rest_client.add_domain("myfirsrdomain") }

      it { expect { run }.to exit_with_code(101) }
      it { run_output.should match(/Application myapp does not exist/) }

      context 'with apps' do
        let(:arguments) { ['clone','http://myapp-myfirsrdomain.startappcloud.com'] }
        before{ domain.add_application('myapp') }

        it { expect { run }.to exit_with_code(216) }
        it { run_output.should match(/Cloning into 'myapp'/) }
      end
    end

  end
end
