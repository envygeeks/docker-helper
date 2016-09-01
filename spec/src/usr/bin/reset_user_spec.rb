require "rspec/helper"
describe "cleanup" do
  before :each do
    run_command("reset-user man:600")
      .exit_status
  end

  #

  context do
    before :each do
      run_command("reset-user man:1000")
        .exit_status
      end

      #

      it "should modify the users UID" do
        expect(run_command("getent passwd man").stdout).to start_with(
          "man:x:1000"
        )
      end

      #

      it "should modify the users GID" do
        expect(run_command("getent group man").stdout).to start_with(
          "man:x:1000"
        )
      end
    end

  context "on Alpine GNU/Linux" do
    it "should install shadow to do it's work", :alpine do
      expect(run_command("reset-user man:1000").stdout).to match(
        /installing shadow@community/i
      )
    end

    #

    it "should remove shadow", :alpine do
      expect(run_command("reset-user man:1000").stdout).to match(
        /purging shadow/i
      )
    end
  end
end
