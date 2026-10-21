# Recipes

**Scope:** six set pieces that assemble the
chapters. Each states what it needs. Two are
verified end to end on the build machine;
the rest are assembled from captured tool
behaviour and are marked as needing the
dongle they describe.

## 1. Decode the lab recording, three ways

**Needs:** no hardware. **Verified.**

```
$ ./dump1090 --ifile testfiles/modes1.bin          # dissected messages
$ ./dump1090 --ifile testfiles/modes1.bin --raw    # hex frames, 217 lines
$ ./dump1090 --ifile testfiles/modes1.bin --stats  # the decoder's audit
```

Success looks like chapter 5: callsign
AMC421, one ICAO address (4d2023) behind
every frame, 217 usable messages in the
audit. This is the rehearsal for every
other recipe — if a tool chain works on the
recording, the only variable left in the
live versions is the sky.

## 2. Feed the same sky to the wrong tools

**Needs:** no hardware. **Verified.**

```
$ dump1090-mutability --ifile modes1.bin   # maintained fork, 2.4 MHz assumption
$ rtl_433 -r modes1.bin                    # sensor decoder, wrong grammar entirely
```

Success is silence, twice, for two different
reasons: a sample rate the fork doesn't
share with the recording (chapter 5), and a
decoder whose expectations the signal never
meant to meet (chapter 6). Run this pair
whenever a live setup goes quiet and you
need reminding that "nothing decoded" is a
statement about the chain, not about the
sky.

## 3. Label and measure an audio capture

**Needs:** no hardware. **Verified.**

```
$ sox -t raw -r 24000 -e signed-integer -b 16 -c 1 in.raw out.wav
$ soxi out.wav
$ sox out.wav -n stats
```

The first command is the one the hobby
reaches for after every `rtl_fm` session
that ended in a file: the raw stream knows
nothing about itself, so you state its
rate, encoding, and channels, and sox
writes the header that makes it a citizen.
`soxi` confirms the label; `stats` measures
levels and length — the build machine's
run (chapter 3) put a synthesised tone
through exactly this and read back
2.000 s at an honest −6 dB.

## 4. Hear your first station

**Needs:** dongle, telescopic antenna,
a strong local FM station. *Documented —
the build machine could not run it.*

```
$ rtl_fm -f 96.1M -M wbfm -s 170k -r 32k - | aplay -r 32000 -f S16_LE
```

Substitute your station's frequency. Extend
the dipole toward the band's half-wave —
chapter 2's arithmetic says about 1.5 m
tip to tip at 100 MHz, longer than most
kits reach, so fully out is the honest
compromise — and put the antenna near a
window. Success is recognisable
speech or music. Silence, in order of
likelihood: the antenna is indoors and low;
the frequency format surprised the tool
(it accepts `96.1M` or `96100000`, and a
bare `96.1` tunes near DC); the kernel's
TV driver took the dongle (chapter 9).

## 5. Walk the airband

**Needs:** dongle, patience. *Documented.*

```
$ rtl_fm -f 118M:137M:25k -M am -l 60 - | aplay -r 24000 -f S16_LE
```

The scan form of chapter 3's command:
aviation's 118–137 MHz in 25 kHz steps, AM
demodulation, squelch at 60 so the walk
pauses only on a voice. Success is
intermittent — tower and aircraft calls are
seconds long with minutes between — and a
quiet ten minutes near a small airfield is
a normal outcome, not a failure. Near a
major airport it is a conversation.

## 6. Record a slice of sky for later

**Needs:** dongle, disk. *Documented; the
decode half is recipe 1.*

```
$ rtl_sdr -f 1090000000 -s 2000000 -g 50 sky.bin
```

`rtl_sdr` is the firehose with no opinions:
raw I/Q to a file at the rate you set.
Do the chapter 4 arithmetic before you
start — 2 Msps × 2 bytes is 4 MB a second,
240 MB a minute — and record in bursts with
a purpose. Name files with the frequency
and sample rate in them (`sky-1090mhz-2msps
.cu8` is a name your future self will
thank), because a recording without its
rate is chapter 5's silent trap waiting
for a victim.
