execute "brow_up" do
  command %(su vagrant -lc 'PATH=/usr/sbin:$PATH brow restart --hard')
end
