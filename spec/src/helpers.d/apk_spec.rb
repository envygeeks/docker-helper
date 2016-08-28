require "rspec/helper"

describe "docker-helper" do
  describe "install-from-apk-file" do
    before :each do
      basic_command "echo vim > .apk"
    end

    #

    context "when given an apk file" do
      it "should install the apks from the file", :alpine do
        out = helper_command "install-from-apk-file"
        expect(out.stdout).to match(
          %r!installing vim!i
        )
      end
    end

    #

    context "when given an apk and apt file" do
      it "should install the only the apks from the apk file", :alpine do
        out = helper_command "install-from-apk-file"
        expect(out.stdout).to match(
          %r!installing vim!i
        )
      end

      #

      after :each do
        basic_command "rm -rf .apt"
      end
    end
  end

  #

  context "when given only an apt file" do
    before :each do
      basic_command "echo vim > .apt"
    end

    #

    it "should convert and try to install the packages", :alpine do
      out = helper_command "install-from-apk-file"
      expect(out.stdout).to match(
        %r!installing vim!i
      )
    end

    #

    after :each do
      basic_command "rm -rf .apt"
    end
  end

  #

  after :each do
    basic_command "apk --update del vim"
    basic_command "rm -rf .apk"
  end
end
