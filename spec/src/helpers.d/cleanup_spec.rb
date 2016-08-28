require "rspec/helper"
describe "docker-helper" do
  describe "cleanup" do
    context "when on Ubuntu do" do
      before do
        basic_command "apt-get update"
      end

      #

      it "should cleanup the apt-cache", :ubuntu do
        helper_command("cleanup").exit_status
        expect(run_commands("ls /var/cache/apt").stdout).to(
          be_empty
        )
      end
    end

    #

    context "when on Alpine do" do
      before do
        basic_command "apk update"
      end

      #

      it "should cleanup apk-cache", :alpine do
        helper_command("cleanup").exit_status
        expect(run_commands("ls /var/cache/apk").stdout).to(
          be_empty
        )
      end
    end
  end
end
