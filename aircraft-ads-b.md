# Aircraft on 1090 MHz

**Scope:** ADS-B — the position beacons
aircraft broadcast in the open — decoded end
to end from this guide's recorded slice of
sky, including the failure that teaches the
most: a healthy decoder hearing nothing
because it assumed the wrong sample rate.

## What ADS-B is

Airliners and most equipped aircraft
broadcast **ADS-B** (Automatic Dependent
Surveillance–Broadcast) messages on
**1090 MHz**: short Mode S radio frames, 112
bits each, announcing identity, position,
altitude, and velocity, roughly twice a
second per aircraft. The broadcasts are
unencrypted by design — air traffic control
is their audience, and the hobby of tracking
aircraft with cheap receivers grew on that
openness. A **Mode S** frame begins with an
8 µs preamble, then pulse-position modulated
bits at one bit per microsecond; at the
recording's 2 MHz sample rate, each bit is
exactly two samples, which is why a decoder
can pick the frames out of a raw stream at
all.

`dump1090` is the decoder that made this the
dongle's flagship use. It was written by
Salvatore Sanfilippo (antirez) as a small C
program, and it is the ancestor of the
maintained forks chapter 8 names. The
project ships a test recording precisely so
the decoder can be tried with no receiver —
that recording is this guide's lab.

## The decode, run

Check: the first message out of the lab
recording, decoded by the original
`dump1090` built from project source on the
build machine:

```
$ ./dump1090 --ifile testfiles/modes1.bin
*8f4d2023587f345e35837e2218b2;
CRC: 000000 (ok)
DF 17: ADS-B message.
  Capability     : 7 (Level 7 ???)
  ICAO Address   : 4d2023
  Extended Squitter  Type: 11
  Extended Squitter  Sub : 0
  Extended Squitter  Name: Airborne Position (Baro Altitude)
    F flag   : odd
    T flag   : non-UTC
    Altitude : 24275 feet
    Latitude : 12058 (not decoded)
    Longitude: 99198 (not decoded)
```

Every line of that is earned. The hex after
`*` is the frame itself. **DF 17** is the
downlink format — an extended squitter, the
ADS-B frame proper. The **ICAO address**
`4d2023` is the aircraft's permanent 24-bit
identity, the closest thing aviation has to
a number plate. The altitude is pressure
altitude in feet. Nothing here was received
by the build machine: it was decoded from a
file, by software, on request — the whole
hobby's workflow in one command.

The same aircraft introduces itself a few
frames later:

```
  Extended Squitter  Name: Aircraft Identification and Category
    Aircraft Type  : Aircraft Type A
    Identification : AMC421
```

**AMC421** is a callsign — the flight's
radio identity, the key that joins a track
to a timetable. Between them, those two
frames are the hobby: an anonymous hex
address becomes a named flight at a stated
altitude.

## What is in the slice

217 usable messages hide in 0.178 seconds.
Counted by downlink format from the full
capture:

| Format | Count | What it is |
| --- | --- | --- |
| DF 17 | 120 | ADS-B extended squitters (position, identity, velocity) |
| DF 11 | 63 | All-call replies — the aircraft answering interrogators |
| DF 0 | 10 | Airborne collision-avoidance replies |
| DF 20 | 8 | Altitude replies carrying data |
| DF 5 | 8 | Identity replies (one gives squawk 112, below) |
| DF 21 | 5 | Identity replies carrying data |
| DF 4 | 3 | Altitude replies (one reads 23,375 feet — the flight is climbing or descending between frames) |

All 217 belong to the one aircraft — a busy
fifth of a second at a real antenna is a
conversation between an airframe, ground
radar interrogators, and its own beacon.
The decoder's own audit of the work:

Check: the same run, asking for statistics
instead of messages:

```
$ ./dump1090 --ifile testfiles/modes1.bin --stats
415 valid preambles
216 demodulated again after phase correction
407 demodulated with zero errors
211 with good crc
196 with bad crc
6 errors corrected
12 single bit errors
0 two bits errors
217 total usable messages
```

Read it as the radio's weather report: 415
candidate frames knocked; nearly half
failed their checksum (collisions and noise
are the band's normal condition); a handful
were rescued by the decoder's single-bit
error correction — the `--fix` behaviour,
on by default in this lineage, which is a
judgement call worth knowing you are making
(chapter 9).

And `--raw` trades the dissection for the
frames alone, one hex line per message —
217 lines, the form other tools in the
chain consume:

```
$ ./dump1090 --ifile testfiles/modes1.bin --raw
*8f4d2023587f345e35837e2218b2;
*5d4d20237a55a6;
*20000f1f684a6c;
...
```

## The position that isn't there (yet)

118 of the capture's position frames end
with the honest words **(not decoded)**.
Airborne position squitters encode latitude
and longitude in a scheme called **CPR**
(Compact Position Reporting) that splits
each position across an *even* frame and an
*odd* frame — the first message above is
flagged `F flag: odd`. One frame alone
yields the raw CPR numbers the decoder
prints; a position emerges only when a
matched pair is combined (or one frame is
combined with a known reference position,
which is how trackers bootstrap). Live
decoders that track aircraft over time —
the maintained forks — do that pairing as a
matter of course and draw the map. The
classic one-shot file decoder shows you the
raw material instead, and labels it plainly.
That is not a defect; it is the difference
between decoding messages and tracking
flights, and knowing which of the two your
tool does is most of reading its output.

## The silence that teaches the most

Check: the same file, fed to the packaged
`dump1090-mutability` — a maintained fork,
same ancestry, same job:

```
$ dump1090-mutability --ifile modes1.bin
Wed Oct 21 22:22:06 2026 UTC  EB_SOURCE EB_VERSION starting up.
Using sample converter: UC8, integer/table path
Wed Oct 21 22:22:06 2026 UTC  Waiting for receive thread termination
Wed Oct 21 22:22:06 2026 UTC  Normal exit.
[exit 0]
```

Zero messages. No error. Exit 0,
"Normal exit." The cause is one assumption:
the recording was made at **2.0 MHz**, and
dump1090-mutability's file reader expects
the **2.4 MHz** sample rate that fork
standardised on for live capture. At the
wrong rate every pulse lands in the wrong
place, no preamble matches, and the decoder
truthfully reports an empty sky — the file
is fine, the aircraft are fine, the
*contract* between them was broken. Its
`--help` (captured in the transcripts)
offers `--iformat` for the sample *format*
but no rate option; the rate is baked in.

Two lessons generalise. First, a recording
is only as useful as its stated sample rate
and format — chapter 4's numbers are not
decoration. Second, **silence is a result**:
"the decoder found nothing" splits into
"nothing was there" and "nothing could be
recognised," and SDR troubleshooting
(chapter 9) is largely telling those apart.
The live version of this same trap is
feeding a decoder the wrong centre
frequency or a mis-set ppm; the shape of
the failure — clean exit, empty output — is
identical.

## From file to live sky

With a dongle, the same program runs
continuously: `dump1090` alone listens;
`--interactive` draws the table of aircraft
currently tracked; `--net` serves the map
and the message streams other tools drink
from. Those modes need hardware this build
never had, so this guide describes their
shape without quoting output it never saw.
The reader's path is short, though: every
concept they exercise — frames, addresses,
pairing, the sample-rate contract — has
already been met here, in a fifth of a
second of somebody else's sky.
