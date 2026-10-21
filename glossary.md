# Glossary

**ADS-B** — Automatic Dependent
Surveillance–Broadcast. The 1090 MHz beacon
system by which aircraft announce identity,
position, altitude, and velocity, in the
open, about twice a second. Chapter 5.

**AGC** — automatic gain control: the
receiver adjusting its own amplification.
Convenient, and the first suspect when a
signal hunts or pumps. Chapters 3, 4.

**Antenna** — the wire that turns radio
waves into a voltage. Its resonant length
is a fraction of the wavelength of what you
want to hear; placement outranks price.
Chapter 2.

**Bandwidth** — the width, in hertz, of a
signal, a filter, or the slice you are
receiving. Every stage of the chain has
one, and they must nest. Chapters 4, 6.

**Bias-T** — a circuit that sends DC power
up the antenna cable to run an amplifier at
the far end, over the same wire that brings
the signal down. Chapter 2.

**Callsign** — a flight's or station's radio
identity: AMC421 in the lab recording.
Chapter 5.

**CPR** — Compact Position Reporting, the
scheme by which ADS-B splits a position
across an even frame and an odd frame,
neither sufficient alone. Chapter 5.

**dB** — decibel, the logarithmic unit of
gain and of signal comparisons. Ratios, not
amounts: +3 dB is double the power,
wherever you start. Chapter 4.

**Decoder** — software that turns a
demodulated signal into structured meaning:
`dump1090` for Mode S frames, `rtl_433` for
sensor packets. A decoder is a set of
expectations; the wrong one hears silence.
Chapters 5, 6.

**Demodulation** — recovering the
information a signal carries (audio from
FM, pulses from a carrier) from the raw
samples. SDR moves this job from hardware
into software. Chapters 1, 3.

**Dongle** — the USB receiver itself: tuner
plus RTL2832U digitiser. Receives only,
never transmits. Chapters 1, 2.

**Downlink format (DF)** — the type number
of a Mode S frame. DF 17 is the ADS-B
extended squitter; the family is counted
in chapter 5.

**Frequency** — where a signal lives in the
spectrum, in hertz (Hz), thousands (kHz),
millions (MHz), billions (GHz). Chapter 4.

**Gain** — amplification applied by the
tuner before digitising, in dB. Too little
buries weak signals in quantisation noise;
too much clips and overloads. Chapter 4.

**I/Q samples** — the dongle's output:
pairs of numbers (in-phase and quadrature)
describing the waveform at one instant,
millions of instants per second. In the
UC8 format, one unsigned byte each.
Chapters 1, 4.

**ICAO address** — an aircraft's permanent
24-bit identity, written in hex: 4d2023 in
the lab recording. Chapter 5.

**ISM band** — spectrum set aside for
industrial, scientific, and medical
gadgets, and — in practice — the domestic
sensor chatter of chapter 6: 433.92 MHz,
868 MHz, 915 MHz, 315 MHz by region.

**LNA** — low-noise amplifier, placed at the
antenna to lift weak signals before cable
loss. Helps a good position; worsens
overload. Chapters 2, 9.

**Mode S** — the aircraft transponder
protocol family ADS-B rides on: 112-bit
frames, pulse-position modulated, with a
24-bit parity check. Chapter 5.

**Noise floor** — the level below which a
signal cannot be distinguished from the
receiver's own and the environment's noise.
Everything receivable lives above it.
Chapter 4.

**Nyquist rate** — the rule that N samples
per second can represent a band N hertz
wide, and no wider. The budget behind every
sample-rate choice. Chapter 4.

**Overload** — the failure where a strong
signal fills the converter's range and
weakens everything else in the slice.
Cured by less gain, not more. Chapters 4, 9.

**ppm** — parts per million, the unit of a
crystal's frequency error. It scales with
frequency: 1 ppm at 1090 MHz is 1090 Hz of
mistake. Chapters 2, 4.

**Sample rate** — I/Q pairs per second, the
width of the window you receive and the
size of the files you record. 2 Msps is
4 MB a second in UC8. Chapter 4.

**SDR** — software-defined radio: hardware
that digitises a slice of spectrum, and
software that decides what the samples
mean. Chapter 1.

**Spectrum** — the whole radio landscape,
frequency laid out as a line from
kilohertz to gigahertz, in which every
signal has an address. Chapter 4.

**Squelch** — a gate that passes audio (or
stops a scan) only when the signal rises
above a set level. Silence, automated.
Chapters 3, 7.

**TCXO** — a temperature-compensated
crystal oscillator; the dongle upgrade
that holds its frequency honest as it
warms up, to about 1 ppm. Chapters 2, 4.

**Tuner** — the dongle's analogue front
end, which selects and amplifies one slice
of the spectrum and mixes it down toward
zero for the digitiser. Chapter 2.

**UC8** — the sample format of the dongle
and its recordings: unsigned 8-bit I and Q,
interleaved, centred on 127. Chapter 4.

**Waterfall** — the GUI receivers' picture
of the spectrum: frequency across, time
down, strength as brightness. Chapter 8.
