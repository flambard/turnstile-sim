#!/usr/bin/ruby

require 'tk'

controller_command = TkVariable.new
command_received = TkVirtualEvent.new

root = TkRoot.new {
  title "Turnstile #{ARGV[0]}".strip
  minsize(200, 100)
}

state_label = TkLabel.new(root) {
  text 'UNINITIALIZED'
  fg 'brown'
  pack { padx 40; pady 40; side 'center' }
}

display_label = TkLabel.new(root) {
  text ''
  pack { padx 40; pady 40; side 'center' }
}

root.bind(command_received) {
  command, args = controller_command.value.split(' ', 2)
  case command
  when "unlock"
    state_label['text'] = "UNLOCKED"
    state_label['fg'] = "darkgreen"
  when "lock"
    state_label['text'] = "LOCKED"
    state_label['fg'] = "red"
  when "display"
    display_label['text'] = "#{args}"
  when "exit"
    exit
  else
    puts "unknown command: #{command}"
  end
}

TkButton.new(root) {
  text "Pass through"
  command proc {
    display_label['text'] = ""
    puts "pass"
  }
  width 16
  pack { fillx 100; pady 100; side 'center' }
}

TkButton.new(root) {
  text "Insert coin"
  command proc {
    display_label['text'] = ""
    puts "coin"
  }
  width 16
  pack { padx 100; pady 100; side 'center' }
}

Thread.new {
  puts "turnstile started"
  while true
    line = $stdin.readline()
    controller_command.value = line.strip
    root.event_generate(command_received)
  end
}

Tk.mainloop
