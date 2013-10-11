# Ruby through RVM

node.set['rvm']['user_installs'] = [
  { 'user'         => 'vagrant',
    'default_ruby' => '1.9.3',
    'rubies'       => ['1.9.3', '2.0.0']
  }
]

include_recipe "rvm::user"
include_recipe "rvm::vagrant"
