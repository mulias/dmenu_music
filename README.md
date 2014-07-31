ruby-dmusic
===========

ruby-dmusic is a [dmenu](http://tools.suckless.org/dmenu/) interface for controlling [mpd](http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki), written in ruby using [dmenu-ruby](https://github.com/dominikh/dmenu-ruby) and [ruby-mpd](https://github.com/archSeer/ruby-mpd).
  
I made this music interface to quickly throw on music without breaking my work flow. With that in mind it has a limited feature set.

In particular, some limitations worth noting are...
* No currently playing blerb - I have a little mpd line on my status bar for this
* Play/Pause, Next, Previous are in the options menu - I have keybindings for basic controls
* No playlist building - If I want a playlist I'll make it somewhere else, then use this to play it
* Crude music selection options - For simplicity, you can either add all music, add all from an artist, add all from an album, or add a specific song

The remaining features boil down to what I actually need to do 90% of the time I'm accessing my music library -- add music to the queue, clear the queue, and turn shuffle on and off. I also sometimes listen to playlists, and I'm experimenting with streaming podcasts. If I need more complex features then I'm likly to use either [mpc](http://linux.die.net/man/1/mpc) or [ario](http://ario-player.sourceforge.net/)

Use
---

Install the needed gems -- `dmenu-ruby` and `ruby-mpd` should both be in the gem repo

Install and configure mpd, if you don't already use it

Clone this repo to wherever you keep executables, `chmod +x dmusic`, make a keyboard shortcut for dmusic

Todo
----
* podcast support  
* playlist support
* Music streaming? I might get spotify premium and that would be cool
* ncurses cli, just for fun
