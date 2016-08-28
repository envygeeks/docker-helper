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
      RUN rm -rf /usr/local/share/docker
      RUN mkdir -p /usr/local/share/docker
      RUN rm -rf /usr/local/bin/docker-helper
      RUN rm -rf /usr/local/bin/docker-helpers
      RUN rm -rf /usr/local/bin/docker-test
      COPY src/ /usr/local/share/docker/
      RUN mkdir -p /test
      WORKDIR /test
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
# Run a command, attaching the path to Docker-Helper.
# So that you do not have to do that yourself.
# --
def helper_command(*cmds)
  if cmds.size > 1
    run_commands(cmds[0...-1],
      "/usr/local/share/docker/docker-helper #{
        cmds.last
      }"
    )

  else
    run_commands(
      "/usr/local/share/docker/docker-helper #{
        cmds.first
      }"
    )
  end
end

# --
# Fire and forget a command on the instance.
# This is globally done.
# --
def basic_command(*cmds)
  return run_commands(*cmds).exit_status
end

# --
# Work around a server spec limitation by wrapping our own method.  See
# when serverspec is inside of a spec, it will create a new instance always
# so we tap into self.class.command so that we don't have that unoptimized
# action that can slow us down more than uninstalling.
# --
def run_commands(*cmds)
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
