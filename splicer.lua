l = require("lattice")
s = require("sequins")
musicutil = require("musicutil")
engine.name = "PolyPerc"

-- Lesson 2: Livecode
-- these variables are meant to be changed in the repl while the script is running

-- adenine is our lead melody and features "nested sequins"
adenine  = s{0,3,5,7,12,s{3,5,7,12,0},s{2,5,7,9,0}}
-- thymine is just an "every other" trigger
thymine  = s{1,0}
at_octave = 0
at_div = 1/16

-- guanine is a simple "rising bassline"
guanine  = s{0,0,0,3,3,3,5,5,5,7,7,7,12,12,12}
-- cytosine is like thymine but with a little bit of variation
cytosine = s{1,s{1,0}}
gc_octave = -2
gc_div = 1/8

-- global root note and tempo
root = 60
tempo = 120

-- some examples of what you can do with the above variables:

-- root = 61
-- root = 62
-- tempo = 140
-- adenine = s{0,4,5,7,12}
-- thymine = s{1,1,1,0,s{0,1,1}}
-- at_div = 1/4
-- gc_div = 1
-- gc_div = 1/3
-- gc_octave = -1
-- at_octave = 1

-- give it a shot(gun sequence)!
-- https://en.wikipedia.org/wiki/Shotgun_sequencing

-- Lesson 3: Beyond
-- the code of splicer has plenty of comments explaining how it works
-- explore the sequins and lattice docs for more built-in behavior
-- and look for a winking smiley face for new project ideas ;)

function init()
  -- lattice uses the norns clock
  -- so lets make sure its set to internal
  clock.set_source("internal")
  -- startup with our variable tempo
  params:set("clock_tempo", tempo)
  -- create a default lattice
  splicer_lattice = l:new()
  -- create the adenine/thymine pattern
  at_pattern = splicer_lattice:new_pattern{
    action = function() at() end,
    division = div
  }
  -- create the guanine/cytosine pattern
  gc_pattern = splicer_lattice:new_pattern{
    action = function() gc() end,
    division = div
  }
  -- create a utility pattern for housekeeping
  utility_pattern = splicer_lattice:new_pattern{
    action = function() utility() end,
    division = 1/16
  }
  -- start the lattice
  splicer_lattice:start()
  -- run the tutorial
  tutorial()
end

function at()
  -- thymine returns 1 or 0
  if thymine() == 1 then
    -- add the at_octave to the note value adenine() returns
    play_note((at_octave * 12) + adenine())
  end
end

function gc()
  -- cytosine returns 1 or 0
  if cytosine() == 1 then
    -- add the gc_octave to the note value guanine() returns
    play_note((gc_octave * 12) + guanine())
  end
end

function play_note(note)
  -- perhaps another Sequins for velocity? ;)
  -- engine.amp(127)
  engine.hz(musicutil.note_num_to_freq(root + note))
end

function utility()
  -- check for tempo updates
  params:set("clock_tempo", tempo)
  -- might be fun to turn the divs into Sequins ;)
  if (at_pattern.division ~= at_div) then
    at_pattern:set_division(at_div)
  end
  if (at_pattern.division ~= gc_div) then
    gc_pattern:set_division(gc_div)
  end
end

function key(k, z)
  -- k2 and k3 just restart the script... for now! ;)
  print("key", k, z)
  if z == 0 then return end
  if k == 2 then rerun() end
  if k == 3 then rerun() end
end

function enc(e, d)
  -- encs do nothing... yet! ;)
  print("enc", e, d)
end

function tutorial()
  hr()
    print("Welcome to splicer!")
  hr()
    print("This is an eduscript for sequins and lattice.")
  hr()
    print("DNA shall be our metaphor for this lesson.")
    print("DNA is a double helix, so we shall have two instances of the \"lattice\", each with one pattern.")
    print("DNA pairs adenine with thymine and guanine with cytosine, so we shall have four instances of \"Sequins.\"")
  hr()
    print("That's where the metaphor ends!")
    print("We'll use our lattice and Sequins to send some notes to the PolyPerc engine.")
    print("Adenine and guanine store note values (pitch).")
    print("Thymine and cytosine store note triggers (on/off).")
    print("Open up /home/we/dust/code/splicer/splicer.lua and scan through the code.")
    print("Find the comment that says \"Lesson 2: Livecode\" to continue the lesson.")
    print("Happy splicing!")
  hr()
    print("Sequins docs: https://monome.org/docs/crow/reference/#sequins")
    print("Lattice docs: https://monome.org/docs/norns/reference/lib/lattice")
  hr()
end

function hr()
  print("")
  print("~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.~.")
  print("")
end

function redraw()
  screen.clear()
  screen.aa(0)
  screen.level(15)
  screen.move(64,8)
  screen.text_center("splicer eduscript")
  screen.move(64,16)
  screen.text_center("for sequins & lattice")
  screen.move(64,24)
  screen.text_center("no gui! open the repl!")
  screen.move(64,32)
  screen.text_center(";)")
  screen.update()
end

-- type rerun() or r() in the reple to restart
function rerun()
  norns.script.load(norns.state.script)
end

function r()
  rerun()
end