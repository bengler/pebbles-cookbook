# Fix cause of 'stdin: not a tty' warnings from Chef
execute "fix_not_a_tty_warning" do
  command "sed -ie 's/^mesg n$/if `tty -s`; then\\n  mesg n\\nfi/' /root/.profile"
end
