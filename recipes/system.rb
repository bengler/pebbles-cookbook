# Fix cause of 'stdin: not a tty' warnings from Chef
execute "Fix not-a-tty warning" do
  command %(sed -ie 's/^mesg n$/if `tty -s`; then\\n  mesg n\\nfi/' /root/.profile)
end

# Configure locale
language = 'nb_NO.utf8'

execute "Add locale" do
  command %(locale-gen #{language})
  not_if  %(locale -a | grep -qix #{language})
end

execute "Set system locale" do
  command %(update-locale LANG=#{language})
  not_if  %(cat /etc/default/locale | grep -qix LANG=#{language})
end

# Allow vagrant user to run sudo with no password
sudoers_file = '/etc/sudoers'
vagrant_spec = 'vagrant  ALL= (ALL:ALL) NOPASSWD: ALL'
execute "vagrant_sudo_without_password" do
  command %(echo "#{vagrant_spec}" >> #{sudoers_file})
  not_if  %(grep -qix "#{vagrant_spec}" #{sudoers_file})
end
