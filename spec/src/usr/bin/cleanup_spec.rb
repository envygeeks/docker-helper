require "rspec/helper"
describe "cleanup" do
  context "on Ubuntu GNU/Linux" do
    before do
      run_command("apt-get update")
        .exit_status
    end

    #

    it "should cleanup the apt-cache", :ubuntu do
      run_command("cleanup").exit_status
      expect(run_command("ls /var/cache/apt").stdout).to(
        be_empty
      )
    end
  end

  #

  context "on Alpine GNU/Linux" do
    before do
      run_command("apk update")
        .exit_status
    end

    #

    it "should cleanup apk-cache", :alpine do
      run_command("cleanup").exit_status
      expect(run_command("ls /var/cache/apk").stdout).to(
        be_empty
      )
    end
  end
end
