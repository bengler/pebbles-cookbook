# Ruby through RVM
node.set['rvm']['default_ruby'] = 'ruby-1.9.3'
include_recipe "rvm::system"
include_recipe "rvm::vagrant"
