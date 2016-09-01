# Frozen-string-literal: true
# Copyright: 2015 Jordon Bedwell - MIT License
# Encoding: utf-8

$VERBOSE = nil
require "rspec"
require "luna/rspec/formatters/checks"
require "serverspec"
require "pathutil"
require "docker"

# --

unless /^(ubuntu|alpine)$/ =~ ENV["OS"]
  ENV["OS"] = "ubuntu"
end

# --

RSpec.configure do |config|
  config.filter_run_excluding(
    ENV["OS"] == "ubuntu" ? :alpine : :ubuntu
  )

  config.before :all do
    @root = Pathutil.new(__dir__).join("..", "..", "src").expand_path
    @tmpd = Pathutil.tmpdir

    @root.safe_copy(@tmpd.join("src"), :root => @root)
    @tmpd.join("Dockerfile").write <<~Dockerfile
      FROM envygeeks/#{ENV["OS"]}
      RUN mkdir -p /test
      WORKDIR /test
      COPY src/ /
    Dockerfile

    @img = Docker::Image.build_from_dir(
      @tmpd.to_s
    )

    set :os, family: :debian
    set :docker_image, @img.id
    set :backend, :docker
  end
end

# --
# Work around a server spec limitation by wrapping our own method.  See
# when serverspec is inside of a spec, it will create a new instance always
# so we tap into self.class.command so that we don't have that unoptimized
# action that can slow us down more than uninstalling.
# --
def run_command(*cmds)
  cmds = cmds.join(" && ")
  if self.class.respond_to?(:command)
    then self.class.command(
      cmds
    )

  else
    command(
      cmds
    )
  end
end
