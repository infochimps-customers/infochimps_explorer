# What Environment are we in?
RACK_ENV = ENV["RACK_ENV"] || "development" unless defined?(RACK_ENV)
ENV["RACK_ENV"] = RACK_ENV
is_production = (!!ENV['GEM_STRICT']) || (RACK_ENV == 'production') || (RACK_ENV == 'staging')

# Source directories for this project
::ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined?(::ROOT_DIR)
def ROOT_DIR.path *dirs
  File.join(::ROOT_DIR, *dirs)
end
$LOAD_PATH.unshift(ROOT_DIR.path("lib")) unless $LOAD_PATH.include?(ROOT_DIR.path("lib"))

# try the given block; if the condition is false, try running
# config/bootstrap. If the condition is still false, fail
def try_or_exec_bootstrap try_bootstrap=true, &block
  if try_bootstrap && (not block.call)
    cmd = ROOT_DIR.path("config/bootstrap.rb")
    warn "WARN The gem environment is out-of-date or has yet to be bootstrapped."
    warn "     Runnning '#{cmd} --local' to remedy this situation. "
    warn "     if you get an error about 'rake' or somesuch not installed, "
    warn "     run #{cmd} explicitly (without the --local flag)."
    system cmd, "--local"
  end
  if not block.call
    warn "FAIL The gem environment is out-of-date. Run 'bundle install' explicitly and then retry"
    fail "gem environment not configued"
  end
end

if is_production
  # Verify the environment has been bootstrapped by checking that the .bundle/loadpath file exists.
  try_or_exec_bootstrap(false) do
    File.exist?(ROOT_DIR.path(".bundle/loadpath"))
  end
else
  # Run a more exhaustive bootstrap check in non-production environments by making
  # sure the Gemfile matches the .bundle/loadpath file checksum.

  # Verify the environment has been bootstrapped by checking that the .bundle/loadpath file exists.
  try_or_exec_bootstrap do
    File.exist?(ROOT_DIR.path(".bundle/loadpath"))
  end
  try_or_exec_bootstrap do
    checksum = File.read(ROOT_DIR.path(".bundle/checksum")).to_i rescue nil
    `cksum <'#{ROOT_DIR.path}/Gemfile'`.to_i == checksum
  end
end

# Disallow use of system gems by default in staging and production environments
# or when the GEM_STRICT environment variable is set. This ensures the gem
# environment is totally isolated to only stuff specified in the Gemfile.
if is_production
  ENV['GEM_PATH'] = ROOT_DIR.path(".vendor/gems")
  ENV['GEM_HOME'] = ROOT_DIR.path(".vendor/gems")
elsif !ENV['GEM_PATH'].to_s.include?(ROOT_DIR.path(".vendor/gems"))
  ENV['GEM_PATH'] =
    [ROOT_DIR.path(".vendor/gems"), ENV['GEM_PATH']].compact.join(':')
end

# Setup bundled gem load path.
paths = File.read(ROOT_DIR.path(".bundle/loadpath")).split("\n")
paths.each do |path|
  next if path =~ /^[ \t]*(?:#|$)/
  path = ROOT_DIR.path(path)
  $: << path if !$:.include?(path)
end

# Child processes inherit our load path.
ENV['RUBYLIB'] = $:.compact.join(':')
