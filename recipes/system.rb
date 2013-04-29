# Fix cause of 'stdin: not a tty' warnings from Chef
execute "fix_not_a_tty_warning" do
  command "sed -ie 's/^mesg n$/if `tty -s`; then\\n  mesg n\\nfi/' /root/.profile"
end

# Configure proper locale settings
language = 'en_US.UTF8'
execute "Set system locale" do
  command "update-locale LANG=#{language}"
  not_if "cat /etc/default/locale | grep -qx LANG=#{language}"
end
