# The Dongle and the Antenna

**Scope:** the hardware half of the hobby —
what the dongle's two chips each do, what the
variants differ in, and why the antenna, a
piece of wire, decides more than any of it.

**A word before the chapter starts:** the
build machine has no dongle. Everything here
is stated from the projects' documentation
and from arithmetic shown in place — the
first chapter said so, and `criteria.md`
keeps the ledger. Nothing in this chapter is
a capture.

## Two chips, two jobs

The dongle is a pipeline of two:

- **The tuner** (commonly an R820T2; older
  sticks used the E4000 or FC0012) is an
  analogue radio front end. It takes the
  whole sky at the antenna and selects one
  slice of it: it mixes the slice around
  your chosen centre frequency down to
  around zero hertz, and amplifies it by
  your chosen **gain**. The tuner decides
  the dongle's frequency range — roughly
  500 kHz to 1.75 GHz for the R820T2 family.
- **The RTL2832U** digitises that slice: an
  analogue-to-digital converter sampling
  both the in-phase (I) and quadrature (Q)
  components, up to a few million sample
  pairs per second, 8 bits per component.
  It then streams those numbers over USB.
  It understands nothing about radio
  protocols; that ignorance is the point.

Everything after the USB cable — filtering,
demodulation, decoding — is ordinary
software, and chapters 3 to 6 are about it.

## The variants you will meet

| Kind | What it is | What differs |
| --- | --- | --- |
| Generic DVB-T stick | The original television dongle | Cheapest; plain crystal (frequency error often tens of ppm, chapter 4), no extras |
| RTL-SDR Blog V3 | The hobby's reference design | 1 ppm TCXO, SMA connector, bias-T power for an active antenna, heatsinking |
| RTL-SDR Blog V4 | The current revision | Different tuner (R828D), built-in upconverter for HF, triple conversion; needs up-to-date drivers — older software sees no device |
| Other SDRs (Airspy, SDRplay, HackRF) | Purpose-built receivers | Wider bandwidth, more bits per sample, higher prices; this guide's tools partly apply, partly don't — chapter 8 places them |

Two of those rows deserve emphasis. A **TCXO**
is a temperature-compensated crystal
oscillator: it keeps the dongle's idea of a
frequency honest as it warms up. And driver
age matters: new hardware revisions can be
invisible to old builds of the library, one
of the genuine causes of the "No supported
devices found" message in chapter 9.

## The antenna is the receiver

A receiver can only decode what reaches it,
and what reaches it is decided by the
antenna and its placement far more than by
anything in software. The physics that
matters at this level is one formula — the
**wavelength** of a frequency:

```
wavelength = speed of light / frequency
           = 299,792,458 / 1,090,000,000   (for ADS-B)
           ≈ 0.275 m  ≈ 27.5 cm
```

An antenna resonates when its elements are a
simple fraction of that length. The two
fractions every kit uses:

- a **quarter-wave** element, ≈ 6.9 cm at
  1090 MHz — the stubby whip in the box;
- a **half-wave dipole**, ≈ 13.75 cm in
  total, two quarter-wave legs — the
  telescopic dipole most kits ship, whose
  legs you extend to the length your target
  frequency asks for.

Check the same arithmetic at the other band
this guide visits: at 433.92 MHz the
wavelength is ≈ 69.1 cm, so a quarter-wave
is ≈ 17.3 cm. The telescopic legs that were
right for aircraft are far too short for the
sensor band; the kit's longer antenna, or
legs fully extended, is the honest answer.
Antenna length is not a detail. A dongle
with the wrong-length antenna is a deaf
dongle with excellent software.

Placement beats hardware, in this order:
**height** (signals are line-of-sight at
these frequencies; a windowsill beats a
basement desk), **clearance** (away from
the computer itself — USB noise is real and
it radiates from the machine the dongle is
plugged into; a short USB extension lead is
the standard fix), and only then gain and
amplifiers. An **LNA** (low-noise amplifier)
at the antenna, powered through the cable
by the dongle's **bias-T**, helps a long
cable run earn its keep; it cannot rescue a
bad position, and in a city full of strong
transmitters it can overload the front end
into deafness (chapter 9).

## Connectors, briefly

Kits speak **SMA** (the small screw-on
connector) or the older push-on **MCX**.
Adapters exist and each one costs a little
signal. The dongle end is female SMA on the
Blog designs; when you buy an antenna, match
the connector and its gender, and distrust
any listing that doesn't state both.
