require "rspec/helper"

describe "docker-helper" do
  describe "os/operating-system" do
    it "should report ubuntu", :ubuntu do
      out = helper_command "os"
      expect(out.stdout).to eq(
        "ubuntu\n"
      )
    end

    #

    it "should report alpine", :alpine do
      out = helper_command "os"
      expect(out.stdout).to eq(
        "alpine\n"
      )
    end
  end

  #

  describe "create-log" do
    before :each do
      helper_command("create-log daemon hello.log")
        .exit_status
    end

    #

    it "should chown the log file" do
      expect(file("/var/log/hello.log").owner).to eq(
        "daemon"
      )
    end

    #

    it "should create the file" do
      expect(file("/var/log/hello.log")).to(
        exist
      )
    end

    #

    context "when given a sub-directory" do
      before do
        helper_command("create-log daemon world/hello.log")
          .exit_status
      end

      #

      it "should create that sub-diretory" do
        expect(file("/var/log/world/hello.log")).to(
          exist
        )
      end

      #

      after do
        basic_command "rm -rf /var/log/world/hello.log"
      end
    end

    #

    after :each do
      basic_command "rm -rf /var/log/hello.log"
    end
  end

  #

  describe "create-dir" do
    before :each do
      helper_command("create-dir daemon /hello")
        .exit_status
    end

    #

    it "should chown the directory" do
      expect(file("/hello").owner).to eq(
        "daemon"
      )
    end

    #

    it "should create the directory" do
      expect(file("/hello")).to(
        exist
      )
    end

    #

    after :each do
      basic_command "rm -rf /hello"
    end
  end

  #

  describe "test-sha" do
    let :sha do
      run_commands("touch /hello.txt && sha256sum /hello.txt")
        .stdout.split(/\s+/).first
    end

    #

    it "should fail if it cannot match the sha" do
      out = helper_command "test-sha /hello.txt broken"
      expect(out.exit_status).not_to eq(
        0
      )
    end

    #

    it "should pass if the sha matches" do
      out = helper_command "test-sha /hello.txt #{sha}"
      expect(out.exit_status).to eq(
        0
      )
    end

    #

    after :each do
      basic_command "rm -rf /hello.txt"
    end
  end

  #

  describe "get-file-uid" do
    before :each do
      basic_command "touch /hello.txt"
    end

    #

    it "should return the user" do
      out = helper_command("get-file-uid /hello.txt")
      expect(out.stdout).to eq(
        "0\n"
      )
    end
  end
end
