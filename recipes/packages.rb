# Update package repository list initially and again if
# more than 24h has passed since last time
execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    !(File.exists?('/var/lib/apt/periodic/update-success-stamp')) ||
      (File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400)
  end
end

# Required Ubuntu packages not installed by default
package "curl"
package "libcurl4-openssl-dev"
package "locales"
package "memcached"

# Useful Ubuntu packages
package "screen"
