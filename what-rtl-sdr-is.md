# What RTL-SDR Is

**Scope:** the mental model — a TV dongle
repurposed as a general radio receiver, the
computer doing the radio's job in software —
plus the one legal line that governs the whole
hobby, and the lab this guide is verified on.

## A television tuner that escaped

In the late 2000s, cheap USB sticks for
receiving digital television became common.
Inside most of them sat two chips: a tuner
(the part that selects one frequency out of
the air) and a Realtek **RTL2832U**, which
digitised whatever the tuner selected and
handed it to the computer. The RTL2832U had a
mode its designers did not advertise: instead
of handing over decoded television, it could
hand over the **raw digitised radio signal**
itself — a stream of numbers describing the
waveform, millions of them per second.

In 2012, experimenters (the discovery is
usually credited to Antti Palosaari, with
Eric Fry and the Osmocom community building
the first drivers) published what that mode
meant: a television dongle costing about the
price of a pizza was, in fact, a **general
purpose radio receiver** covering, depending
on the tuner chip, roughly 500 kHz to
1.75 GHz — provided the computer did the
rest of the radio's work. **Software-defined
radio** (SDR) is that arrangement: the
hardware samples the air, and software —
demodulators, decoders, filters — decides
what the samples mean. Change the software
and the same dongle is an FM radio, an
aircraft tracker, a weather-station listener,
or a spectrum surveyor.

## What it cannot do

State it before anything else, because the
name misleads: **an RTL-SDR only receives.**
There is no transmitter in it. It cannot
talk to the aircraft it tracks, answer the
sensors it hears, or interfere with anything
except by being one more USB device on your
desk. The hobby is listening and decoding,
full stop.

## The legal line, once and plainly

Listening rules differ by country, and this
guide is not a lawyer, but the shape of them
is consistent enough to state:

- **Broadcast and openly transmitted data**
  — FM radio, aircraft ADS-B, weather
  satellites, sensor beacons — is the normal
  territory of this hobby and is lawful to
  receive in most places.
- **Private communications are not.** In
  many jurisdictions it is illegal to listen
  to, record, or disclose communications not
  intended for you — phone calls and
  encrypted traffic above all. Encryption is
  also a practical wall: the dongle hears
  the noise and no more.
- Transmitting is a separate, licensed
  business that this hardware cannot do
  anyway (see the sibling guide, *Ham Radio
  for Mere Mortals*).

When in doubt about a frequency, look it up
before you settle there. The chapters of this
guide stay inside the openly transmitted
territory.

## The pieces

Every capture in this guide involves the same
four pieces, and the chapters refer back to
them:

- **The antenna**, which turns radio waves
  into a voltage. Chapter 2; it matters more
  than everything else combined.
- **The tuner**, which picks a slice of the
  spectrum — its centre **frequency** and a
  width set by the **sample rate** — and
  mixes that slice down to zero.
- **The RTL2832U**, which digitises the
  slice into **I/Q samples**: pairs of
  numbers, one pair per instant, at up to
  a few million instants per second.
- **The software**, which filters, demodulates
  and decodes the stream. That is the
  `rtl_*` tools, `dump1090`, `rtl_433`, and
  their neighbours.

## The lab, and its honest ceiling

This guide was built and verified on a
machine with **no dongle and no antenna**.
That sounds like a disqualification; it is
actually a demonstration of the hobby's best
feature — the signal is a file. Everything
checkable was checked:

Check: the tools, installed from the Ubuntu
24.04 archive on the build machine:

```
$ dpkg-query -W rtl-sdr dump1090-mutability rtl-433 sox
dump1090-mutability   1.15~20180310.4a16df3+dfsg-8.1build1
rtl-433               23.11-1build1
rtl-sdr               2.0.1-2build1
sox                   14.4.2+git20190427-4build4
```

Check: what every receiver tool says on a
machine with no receiver. They agree, and the
agreement is itself the first lesson — this
message means "the software is installed and
the hardware is not":

```
$ rtl_test
No supported devices found.
[exit 1]
$ rtl_fm -f 96.1M -s 200k -
No supported devices found.
[exit 1]
$ dump1090-mutability
...
No supported RTLSDR devices found.
[exit 1]
```

And one thing was fully verified with a live
decode: a **recording** of real 1090 MHz
aircraft traffic, `modes1.bin`, distributed
with the original `dump1090` project so the
decoder can be exercised with no hardware at
all. It is 0.178 seconds of sky containing
217 usable messages from one aircraft, and
chapter 5 takes it apart line by line. Get
your copy with `examples/fetch-sample.sh`;
`examples/lab-notes.txt` gives its size,
provenance, and hash.

What no transcript here can show you is a
signal the build machine received, because
it received none. Chapters 2 and 3 teach the
antenna and the first-listen workflow from
the tools' own captured behaviour — their
usage text, their planners, their error
messages — and `criteria.md` keeps the ledger
of exactly which claims are documented-only.
That is the honest shape of this guide, and
it matches the hobby more than you'd think:
half of SDR is files, settings, and decoding
chains, and all of that is checkable on any
machine, dongle or not.
