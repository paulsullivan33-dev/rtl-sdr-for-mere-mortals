# The Neighbours

**Scope:** everything around the dongle's
own toolkit — the receivers with dials, the
maintained descendants of `dump1090`, the
strangers' receivers you can borrow through
a browser, and the construction kit
underneath it all. None of these were run
on the build machine; this chapter places
them, and says so.

## The GUI receivers: GQRX, SDR++, SDRangel

The `rtl_*` tools are deliberately bare —
numbers in, audio or data out, no picture.
The graphical receivers put the radio back
on the screen: a **waterfall** display of
your slice of spectrum, a tuning dial, and
demodulators you switch with a click.
**GQRX** (Linux and macOS) is the plainest
of them and the usual first picture a new
dongle owner sees. **SDR++** is the
cross-platform modern entry, with a module
system. **SDRangel** goes furthest, bundling
demodulators and decoders (including ADS-B
and many data modes) into one large
application. What they trade: the picture
costs the scriptability chapters 3 to 6
rely on, and a waterfall has ended more
evenings than it has answered questions.
Start with whichever you like; keep the
command-line tools for the work you want
to repeat.

## dump1090's descendants: -fa and readsb

Chapter 5's decoder has a family. The
packaged **dump1090-mutability** in this
guide is one maintained fork; **dump1090-fa**
is FlightAware's, the engine of the PiAware
aircraft feeder, with the SkyAware map.
**readsb** is the actively developed
descendant most new trackers now install:
the same decoding core, better maintained,
designed to run as a service feeding the
**tar1090** web map. If chapter 5 sold you
on a permanent aircraft station, readsb is
where the lineage currently lives — and its
2.4 MHz sample-rate expectation is exactly
the assumption that chapter's silent trap
came from. The original remains the best
*teacher*: it is small, readable, and its
file mode made this guide verifiable.

## Other people's receivers: WebSDR and KiwiSDR

You can practise half this hobby with no
hardware at all. **WebSDR** and **KiwiSDR**
stations are real receivers, owned by
volunteers, whose output streams to anyone's
browser: tune them, choose a demodulator,
listen. They are how you learn what the HF
bands sound like at 3 a.m. in another
hemisphere, and how you check whether a
silence is your dongle or the band itself.
What they cannot teach is the local half —
your antenna, your noise, your sky — which
is chapters 2 and 9. Borrow their ears
freely; the etiquette is that of any shared
instrument: you are one of many listeners,
and the receiver stays where its owner put
it.

## pyModeS: the frames, in Python

Chapter 5's `--raw` output — 217 lines of
hex — is a data source looking for a
program. **pyModeS** is the library that
decodes Mode S and ADS-B frames in Python,
frame by frame, with the CPR position maths
this guide deliberately left at the raw
numbers. It is the natural next step after
the recording: the same sky, interrogated
by your own code instead of a finished
tool.

## The construction kit: GNU Radio

Every tool in this guide is, underneath, a
chain of blocks — filter, mix, demodulate,
decode — plumbed in a fixed order. **GNU
Radio** lets you build those chains
yourself, graphically or in Python, from
the dongle's raw stream. It is a subject
the size of this whole guide, and this
guide's honest place for it is a pointer:
when the decoder you want doesn't exist,
or you want to know what a demodulator
*is* rather than which flag selects it,
that is the door.

## And the transmitting half

This dongle will never transmit; the
licence that lets a person do so lawfully,
and the radios that follow from it, belong
to the sibling guide, *Ham Radio for Mere
Mortals*. The two hobbies share the
spectrum, the antenna maths, and half the
vocabulary — this guide's glossary will
feel familiar there.
