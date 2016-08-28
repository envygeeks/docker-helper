require "rspec/helper"

describe "docker-helper" do
  describe "install-from-apt-file" do
    before :each do
      basic_command "echo vim > .apt"
    end

    #

    context "when given an apt file" do
      it "should install the debs from the apt file", :ubuntu do
        out = helper_command "install-from-apt-file"
        expect(out.stdout).to match(
          %r!setting up vim!i
        )
      end
    end

    #

    after :each do
      basic_command "apt-get autoremove --purge vim -y"
      basic_command "rm -rf .apt"
    end
  end

  #

  describe "apt-clean" do
    before :each do
      basic_command "sudo apt-get update"
      basic_command "sudo apt-get install --no-install-recommends " \
        "libxml2-dev -y"
    end

    it "should remove development packages", :ubuntu do
      out = helper_command "apt-clean"
      expect(out.stdout).to match(
        %r!removing libxml2-dev!i
      )
    end
  end
end
