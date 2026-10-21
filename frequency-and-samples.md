# Frequency and Samples

**Scope:** the four numbers that run the
whole hobby — frequency, bandwidth, sample
rate, and gain — plus the fifth, ppm, that
explains why cheap dongles drift. Every
figure here is either a definition or
arithmetic shown in place; where a tool
computed a plan, the tool's own output is
quoted.

## Frequency is an address

A **frequency** names where in the spectrum
something lives: cycles per second, counted
in hertz. The dongle's world spans roughly
500 kHz to 1.75 GHz — five orders of
magnitude containing FM radio at ~100 MHz,
the sensor band at 433.92 MHz, aircraft at
1090 MHz, and a great deal of silence
between landmarks. Tuning is choosing an
address; everything else in this chapter is
about how much of the neighbourhood around
that address you see, and how clearly.

## Sample rate is the width of the window

The dongle does not deliver one frequency.
It delivers a **slice**: everything within
a band centred on your tuned frequency, as
a stream of I/Q sample pairs. The **sample
rate** — pairs per second — sets the slice's
width, by the rule Nyquist proved: a stream
of N samples per second can represent
frequencies across a band N wide, no more.

Worked example, the numbers this guide's
lab actually runs on: the aircraft recording
was made at **2,000,000 samples per second**.
Tuned to 1090 MHz, that is a window from
1089 to 1091 MHz — wide enough for ADS-B,
whose pulses occupy about a megahertz
either side of the carrier, and nothing
outside the window exists as far as the
decoder is concerned.

The costs of width are arithmetic too:

- Data rate = sample rate × 2 bytes (one
  byte each for I and Q, in the `UC8` format
  the dongle and the recordings use).
  At 2.4 Msps — a common working rate — that
  is **4.8 MB per second**, so a one-minute
  recording is **288 MB**, and an unattended
  hour is about 17 GB. Recording the sky is
  a disk-management hobby inside the radio
  hobby.
- The dongle's converters run up to about
  3.2 Msps on paper, but sustained rates
  above ≈ 2.4 Msps drop samples on typical
  hardware; the tools' defaults (2.048 Msps
  is `rtl_sdr`'s) live under that ceiling
  for a reason.

## rtl_power plans a survey in exactly these terms

`rtl_power` sweeps a range by hopping the
window across it and logging power per bin.
Told to survey the FM band in 100 kHz bins
on the build machine, it printed its whole
plan — in this chapter's vocabulary — before
meeting the missing dongle:

Check: the plan is the tool's own
calculation, captured:

```
$ rtl_power -f 88M:108M:100k -i 1 -1 -
Number of frequency hops: 8
Dongle bandwidth: 2500000Hz
Downsampling by: 1x
Cropping by: 0.00%
Total FFT bins: 256
Logged FFT bins: 256
FFT bin size: 78125.00Hz
Buffer size: 16384 bytes (3.28ms)
Reporting every 1 seconds
No supported devices found.
[exit 1]
```

Read it as the chapter in miniature: a
2.5 MHz window cannot cover 20 MHz at once,
so the survey takes **8 hops**; each hop's
spectrum is divided into 256 bins of
**78,125 Hz** — the tool quietly widened
your requested 100 kHz bins to what its
arithmetic allows, which is why reading the
plan matters more than trusting the
request.

## Gain is a volume knob with a ceiling

**Gain**, in decibels (dB), is how much the
tuner amplifies the slice before digitising.
The 8-bit converter behind it has a fixed
range, and gain is the art of fitting your
signal into it:

- **Too little gain** and a weak signal
  occupies the converter's lowest few
  values, drowned in its own quantisation
  noise.
- **Too much gain** and strong signals
  clip — the waveform's peaks flatten
  against the converter's ceiling, and a
  loud neighbour anywhere in the slice can
  deafen the whole window. This failure is
  **overload**, and in a city it is the
  common one.

Automatic gain lets the tool hunt; fixed
gain (`-g` in both `rtl_fm` and `dump1090`)
is what you set once you know your local
sky. There is no universally right number —
any guide that gives one without asking
about your antenna and your neighbours is
guessing.

## ppm: why the dongle's ruler is bent

The dongle measures frequency against its
crystal, and a cheap crystal's tick is off
by some **parts per million** (ppm). The
error scales with frequency, which the
arithmetic makes concrete:

```
1 ppm at 1090 MHz  = 1,090,000,000 × 0.000001 = 1,090 Hz
50 ppm at 1090 MHz = 54,500 Hz ≈ 54.5 kHz
```

Fifty ppm is a plausible error for a plain
crystal dongle, and it means the tool
reporting "1090 MHz" may be listening
54 kHz away from it. For ADS-B — a signal
megahertz wide — that is a shrug. For a
narrowband voice channel 12.5 kHz wide, it
is the difference between the channel and
the empty space beside it. A TCXO dongle
(chapter 2) shrinks the error to ~1 ppm;
`rtl_test -p` measures your own dongle's
error against a signal whose frequency you
trust, and most tools accept the result as a
`-p` / `--ppm` correction thereafter.
Measured error, applied: that is the whole
technique.
