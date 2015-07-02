Facter.add('hasdrac') do
  confine :kernel => 'Linux'
  setcode do
    drac = Facter::Core::Execution.exec('racadm getsysinfo 2>/dev/null')
    drac_re = /UNKNOWN/
    nocard = drac_re.match(drac)
    if nocard
      0
    else
      1
    end
  end
end
