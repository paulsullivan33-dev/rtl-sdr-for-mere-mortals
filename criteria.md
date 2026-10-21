# Writing Criteria

Every guide in this repo is written to the same
standard. If you're adding or editing a guide —
human or AI — hold it to these.

1. **Plain words, real ideas.** Simple language,
   never dumbed-down concepts. Explain jargon on
   first use; collect terms in the glossary.
2. **No hype.** No marketing adjectives, no
   "revolutionary," no promises about what
   something will do for the reader.
3. **Honest about limits.** Say what the thing
   *can't* do. State uncertainty instead of
   smoothing it over. Validation notes include
   what remains unverified.
4. **No invented numbers.** Benchmarks, defaults,
   and specs are either measured or qualified with
   "depends on your setup." If it wasn't tested,
   say so.
5. **Checkable.** Commands are meant to be run,
   with "Check:" blocks showing what success looks
   like. Sources are linked, not asserted.
6. **Respect the reader's setup.** Call out
   Windows/Mac/Linux differences. Don't assume a
   GPU, a budget, or prior experience.
7. **Safety isn't skipped.** Real risks get
   stated plainly, not buried.
8. **Scoped.** Each guide says what it covers and
   points elsewhere for the rest. No guide
   pretends to be the whole subject.
9. **Structure over prose.** Tables, before/after
   examples, symptom → fix. Scannable beats essay.

## Verification notes for this guide

Standard 3 and 4 applied to this guide,
specifically, and they cut deeper here than
in most of the series: **the build machine
had no receiver.** Ubuntu 24.04, no RTL-SDR
dongle, no antenna, no RF. The tools were
installed from the Ubuntu archive and run
regardless, and the guide is built from
what that honestly produces: captured
no-device behaviour, captured file-mode
behaviour on one real recording, captured
usage text and planners, and arithmetic
shown in place. Working transcripts are
kept with the build
(`rtl-sdr-lab/transcripts/`).

**The lab.** Two halves. (1) *The
recording:* `modes1.bin`, distributed as
`testfiles/` with the original dump1090
project — 713,736 bytes of unsigned 8-bit
I/Q at 2,000,000 samples per second,
recorded from real 1090 MHz traffic by the
project. 713,736 ÷ 2 = 356,868 sample
pairs; at 2 MHz that is 0.178 seconds.
SHA-256
3a33e16025da8669149c780075950b4e908ca036
ea21f9583c113f60d5fb3094, verified against
both the MalcolmRobb and antirez mirrors
of the project, which serve the identical
file (checked byte-for-byte by hash during
the build). `examples/fetch-sample.sh`
repeats that check for the reader. (2)
*The absence:* every receiver-dependent
command in the guide was run on the
dongle-less machine and its real output
captured; "No supported devices found."
appears in the transcripts for `rtl_test`
(both modes), `rtl_fm`, `rtl_sdr`,
`rtl_adsb`, `rtl_433` (exit 2, its own
banner), and `dump1090-mutability`.

**Tools as installed** (Ubuntu 24.04
archive): rtl-sdr 2.0.1-2build1 with
librtlsdr2 2.0.1-2build1,
dump1090-mutability
1.15~20180310.4a16df3+dfsg-8.1build1,
rtl-433 23.11-1build1, sox
14.4.2+git20190427-4build4. The original
dump1090 (antirez) was built from the
project's source during the build (gcc,
librtlsdr-dev 2.0.1) because its test file
is the lab; the binary itself is a build
artefact, not a repo deliverable.

**Verified by running, per chapter:**

- *Ch. 1:* the package versions as
  installed (`dpkg-query` capture); the
  no-device messages of `rtl_test`,
  `rtl_fm`, and `dump1090-mutability`
  with exit codes.
- *Ch. 3:* `rtl_fm`'s full usage text,
  captured via an invalid option (the
  tool prints usage on a bad flag before
  it touches hardware); `rtl_test -h`
  usage, including the `-p` ppm option
  the chapter cites; the sox chain end
  to end — a synthesised 2-second
  880 Hz tone in the exact raw shape
  `rtl_fm` emits (24 kHz, signed 16-bit,
  mono; 96,000 bytes, matching the
  arithmetic), labelled to WAV with the
  chapter's command, read back by
  `soxi` (2.00 s, 48,000 samples), and
  measured by `sox -n stats`
  (RMS lev −6.05 dB, length 2.000 s).
- *Ch. 4:* `rtl_power`'s survey plan for
  the FM band, captured in full before
  its no-device exit (8 hops, 2.5 MHz
  dongle bandwidth, 256 bins of
  78,125 Hz against the 100 kHz
  requested). All other figures in the
  chapter are definitions or arithmetic
  performed in the text: wavelength at
  1090 MHz (0.275 m), 433.92 MHz
  (0.691 m), 96.1 MHz (3.12 m); data
  rates at 2.0 and 2.4 Msps (4.0 and
  4.8 MB/s; 288 MB per minute at
  2.4 Msps); ppm errors at 1090 MHz
  (1 ppm = 1,090 Hz; 50 ppm = 54.5 kHz).
- *Ch. 5:* the decode itself, three
  ways, on the lab recording, with the
  **original dump1090** (built as above):
  the full dissected output (2,429
  lines, kept whole in the transcripts);
  the callsign frame (Identification
  AMC421, ICAO 4d2023, Type 4); the
  `--raw` output, 217 message lines;
  and `--stats` (415 valid preambles,
  407 demodulated with zero errors, 211
  good CRC, 196 bad CRC, 6 errors
  corrected, 12 single-bit, 217 usable).
  The per-format counts in the chapter's
  table (DF17 120, DF11 63, DF0 10,
  DF20 8, DF5 8, DF21 5, DF4 3) were
  counted from that capture and sum to
  217. The altitudes quoted (24,275 ft
  airborne position; 23,375 ft DF 4;
  squawk 112, DF 5) are lines in it.
  The "(not decoded)" count (118) was
  counted from the same capture; the CPR
  pairing behaviour of the maintained
  forks is described, not demonstrated
  (see Documented-only).
- *Ch. 5, the trap:* `dump1090-mutability
  --ifile modes1.bin` on the identical
  file: starts, reads, "Normal exit",
  exit 0, **zero messages** — captured
  twice. Its `--help` (captured) shows
  `--iformat` and no sample-rate option,
  which is the chapter's stated cause:
  the fork's file path assumes the
  2.4 MHz rate of its live capture.
- *Ch. 6:* `rtl_433`'s banner and
  no-device exit (2); its `--help`
  defaults (433920000 Hz, 250000 Hz,
  `-R`, `-H`); the protocol list counted
  from `-R help` on the build machine —
  **244** numbered entries, the full
  list kept in the transcripts; and the
  file-mode run against the aircraft
  recording: "Test mode active. Reading
  samples from file", followed by zero
  decodes, captured.

**Capture hygiene (declared trims):**
chapter 3 quotes the load-bearing lines
of `rtl_fm`'s usage, not all of it (the
full text is in the transcripts); chapter
5 quotes two message blocks of 217 (the
full decode is in the transcripts) and
three `--raw` lines with an ellipsis;
chapter 6 quotes the first four protocol
entries of 244. The `EB_SOURCE EB_VERSION`
banner lines in dump1090-mutability's
output are the Debian build's own
unexpanded version placeholders, quoted as
captured. Sandbox timestamps in captures
are the build machine's clock (UTC,
October 2026 in its reckoning) and are
weather, not claims. The rtl_433
no-device and file-mode captures contain
the tool's own ANSI colour escapes around
its [SDR] and [Input] tags; chapters quote
the text without the escapes.

**Documented-only (not run), and why:**

- *Everything requiring a live dongle or
  an antenna:* `rtl_test` against real
  hardware (device lines, gain tables,
  sample-loss figures), the tuner
  benchmark, ppm measurement against a
  real signal, actual FM reception and
  audio quality, airband scanning,
  `rtl_power` survey *results* (only its
  printed plan is captured), `rtl_sdr`
  recording, live `dump1090` with
  `--interactive` and `--net`, and every
  live `rtl_433` sensor decode. No
  dongle existed; nothing is quoted as
  if one had been.
- *All hardware claims:* tuner ranges
  (R820T2 ≈ 500 kHz–1.75 GHz), the Blog
  V3/V4 feature sets (TCXO ≈ 1 ppm,
  bias-T, the V4's R828D and built-in
  upconversion and its newer-driver
  requirement), connector and kit facts.
  These are stated from the projects'
  documentation. The dongle price
  framing ("about the price of a pizza")
  is the hobby's standing shorthand, not
  a price check.
- *Installation beyond apt:* the Windows
  route (binary bundles plus Zadig
  driver replacement) and the macOS
  routes (Homebrew/MacPorts) are
  described from the projects'
  documentation; only the Debian/Ubuntu
  packages were installed here, and the
  kernel blacklist step, while standard,
  had no dongle to be tested against.
- *The neighbours:* GQRX, SDR++, and
  SDRangel (not installed; GUI tools on a
  headless build), dump1090-fa and
  readsb/tar1090 (described as the
  lineage's current state; readsb was
  not built), WebSDR and KiwiSDR
  (services, not run), pyModeS (not
  installed; chapter 5's raw output is
  real, its Python decoding is not
  demonstrated), and GNU Radio (named
  and placed only).
- *CPR position pairing:* that the
  maintained forks pair even/odd frames
  into plotted positions is their
  documented behaviour; the build's own
  captures show only the classic
  decoder's raw CPR numbers, and no
  latitude/longitude is quoted anywhere
  in this guide.
- *Satellite reception, HF technique,
  upconverters:* named as territory, not
  taught; nothing about them is quoted
  as experience.

Specimen discipline, for the record: the
lab recording is a genuine historical
capture distributed by the dump1090
project for exactly this purpose. The
aircraft in it broadcast its identity in
the open by design — an ICAO address and a
callsign are the aviation equivalent of a
number plate, transmitted for anyone with
a receiver — and they are quoted because
decoding them is the guide's subject. No
private communication was received,
recorded, or quoted at any point in this
build; the sandbox received no RF at all.
