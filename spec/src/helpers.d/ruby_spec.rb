require "rspec/helper"

describe "docker-helper" do
  describe "has-git-gemfile" do
    it "returns false when there is no Gemfile" do
      out = helper_command "has-git-gemfile"
      expect(out.exit_status).to eq(
        1
      )
    end

    #

    context "when there is no git or github" do
      before do
        basic_command "touch Gemfile"
      end

      #

      it "returns false" do
        out = helper_command "has-git-gemfile"
        expect(out.exit_status).to eq(
          1
        )
      end
    end

    #

    context "when :git" do
      before do
        basic_command "echo ':git => \\\"git@github.com:envygeeks/test.git\\\"'" \
          " > Gemfile"
      end

      #

      it "should report true" do
        out = helper_command "has-git-gemfile"
        expect(out.exit_status).to eq(
          0
        )
      end
    end

    #

    context "when :github" do
      before do
        basic_command "echo ':github => \\\"envygeeks/test.git\\\"' > Gemfile"
      end

      it "should report true" do
        out = helper_command "has-git-gemfile"
        expect(out.exit_status).to eq(
          0
        )
      end
    end

    #

    after do
      basic_command "rm -rf Gemfile"
    end
  end

  #

  describe "ruby-uninstall-depends" do
    before do
      helper_command("install-ruby-depends")
        .exit_status
    end

    #

    it "should uninstall basic ruby depends" do
      out = helper_command "uninstall-ruby-depends"
      expect(out.stdout).to match(
        %r!(purging|removing) ruby\-dev!i
      )
    end
  end

  #

  describe "ruby-install-depends" do
    it "should install basic ruby depends" do
      out = helper_command "install-ruby-depends"
      expect(out.stdout).to match(
        %r!(installing|setting up) ruby\-dev!i
      )
    end

    #

    after :each do
      helper_command("uninstall-ruby-depends")
        .exit_status
    end
  end
end
