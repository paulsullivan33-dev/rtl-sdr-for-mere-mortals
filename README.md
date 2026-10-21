# RTL-SDR for Mere Mortals

A television dongle that costs about as
much as a pizza turns out to contain a
general-purpose radio receiver: a tuner, a
digitiser, and — the discovery that started
the hobby — a mode that hands the computer
the raw radio signal itself, a few million
samples a second. **RTL-SDR** is what grew
on that discovery. The hardware does one
thing, sampling a slice of the spectrum; all
the radio behaviour anyone cares about —
tuning, demodulating, decoding — is
software, and the software is a shelf of
small, sharp command-line tools: `rtl_fm`
for listening, `dump1090` for aircraft,
`rtl_433` for the sensors chattering around
every house, `rtl_power` for surveying a
whole band.

The dongle has a reputation for being a
toy, and it is earned and irrelevant in
equal measure: it is an 8-bit receiver with
a bent frequency ruler, and it has also
tracked more aircraft and decoded more
weather stations than every "real" receiver
most people will ever own. This guide takes
it seriously on exactly those terms — what
it hears, what the numbers on its dials
actually mean, where its limits are, and
what to check when it goes quiet.

The lab is one recording and one absence.
The recording is `modes1.bin`, 0.178
seconds of real 1090 MHz sky distributed
with the `dump1090` project, in which one
aircraft (callsign AMC421) speaks 217 times.
The absence is a receiver: the build machine
has no dongle, and every tool in this guide
was run anyway, so its honest no-hardware
behaviour is captured and quoted. Between
the recording and the absence, everything
checkable in this hobby without an antenna
is checked. What needs the sky is marked as
needing the sky.

A note on how this guide was verified. The
toolkit (rtl-sdr 2.0.1, dump1090-mutability
1.15, rtl-433 23.11, sox 14.4.2, and the
original dump1090 built from project source)
ran on Ubuntu 24.04 with no receiver
attached: the no-device messages, the
decoders' file-mode behaviour on the lab
recording — 217 messages decoded by one
tool, silence from two others for two
different, instructive reasons — and the
audio plumbing downstream of `rtl_fm` are
captures, all kept in
`rtl-sdr-lab/transcripts/`. `criteria.md`
keeps the full ledger of what is
documented-only.

## What this guide covers

- [**What RTL-SDR is**](what-rtl-sdr-is.md) —
  the escaped TV tuner, software doing the
  radio's job, receive-only stated plainly,
  the legal line, and the lab
- [**The dongle and the antenna**](the-dongle-and-the-antenna.md) —
  two chips, two jobs; the variants and their
  crystals; wavelength arithmetic; why the
  wire outranks the software
- [**First listening**](first-listening.md) —
  installing on three systems, the `rtl_test`
  census, broadcast FM through `rtl_fm`, and
  the sox audio chain verified without a radio
- [**Frequency and samples**](frequency-and-samples.md) —
  the window and its width, the data-rate
  bill, `rtl_power`'s survey plan, gain and
  its ceiling, and the bent ruler called ppm
- [**Aircraft on 1090 MHz**](aircraft-ads-b.md) —
  ADS-B decoded from the lab recording line
  by line: one aircraft, its callsign, its
  altitudes, the position that isn't there
  yet, and the sample-rate silence
- [**Sensors and rtl_433**](sensors-and-rtl-433.md) —
  the 433 MHz sensor band, one decoder with
  244 counted dialects, and a wrong-grammar
  experiment that decodes to nothing, honestly
- [**Recipes**](recipes.md) — the lab
  recording three ways, the wrong-tools
  exercise, labelling audio, first FM, the
  airband walk, and recording the sky for later
- [**The neighbours**](the-neighbours.md) —
  the GUI receivers, `dump1090`'s maintained
  descendants, other people's receivers on
  the web, pyModeS, and GNU Radio
- [**Troubleshooting**](troubleshooting.md) —
  the census that says zero, silence with a
  live dongle, overload, the exit-0 decode of
  nothing, drift, dropouts, and a quiet sensor
  band
- [**Glossary**](glossary.md) — the terms,
  collected in one place

## What it doesn't cover

Transmitting — the hardware can't, and the
licensed half of radio lives in the sibling
guide, *Ham Radio for Mere Mortals*. Other
SDR hardware gets placed in chapter 8, not
taught: this guide's tools are the RTL-SDR
family's. HF below the tuner's floor, the
upconverter workarounds, and satellite
reception beyond a mention belong to their
own shelves. And no chapter here will tell
you a "best" gain, a "best" antenna, or a
best anything: the sky is local, and the
guide's job is to make its numbers legible
so your own sky can be measured.

## How to use this guide

Read chapter 1, fetch the lab recording
with `examples/fetch-sample.sh`, and keep a
terminal open from chapter 3 on — every
capture can be reproduced with no hardware
at all, which is the right way to meet
these tools. When a dongle joins the desk,
chapters 2 and 3 turn it on, and nothing
you learned from the recording expires:
the sky is the same, it is only live.

## The lab recording

The fetch script downloads `modes1.bin`
from the dump1090 project and verifies its
SHA-256 against the hash this guide's
captures were made from
(3a33e16025da8669149c780075950b4e908ca036
ea21f9583c113f60d5fb3094). If upstream ever
changes the file, the script says so rather
than letting a different fifth of a second
take the lab's place. `examples/lab-notes.txt`
records the recording's size, provenance,
and the build machine's exact package
versions.
