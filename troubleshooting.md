# Troubleshooting

**Scope:** the failures of the dongle and
its chain, by symptom. The first is the one
this guide's build machine exhibits on
purpose; the most instructive is the one
where everything exits happily and nothing
was heard.

## Symptom: "No supported devices found"

```
$ rtl_test
No supported devices found.
[exit 1]
```

**Cause, in the order to check it:**

1. *There is genuinely no dongle.* This
   guide's lab is that machine, and the
   message is its correct census. Rule it
   in or out before anything else.
2. *On Linux, the kernel's TV driver got
   there first.* The dongle is, by birth, a
   television receiver, and the
   `dvb_usb_rtl28xxu` module claims it for
   TV duty. Blacklist it
   (`blacklist dvb_usb_rtl28xxu` in a file
   under `/etc/modprobe.d/`), replug, and
   the library can see the device.
3. *On Windows, the wrong driver is bound.*
   The fix is Zadig (chapter 3): WinUSB on
   the dongle's bulk-in interface.
4. *Permissions.* The udev rules from the
   `rtl-sdr` package put the device in a
   group your user may not belong to yet;
   log out and back in after installing.
5. *The library is older than the
   hardware.* A Blog V4 (chapter 2) is
   invisible to old builds of the library —
   the message is identical, the cure is an
   up-to-date install, not a new dongle.
6. *A virtual machine never got the USB
   device.* Passthrough is a setting, not
   a default.

## Symptom: dongle found, silence on known stations

**Cause:** the receiving chain, in order.
The antenna first — indoors, low, and
possibly tuned to the wrong length for the
band (chapter 2's fractions are not
suggestions). The computer's own RF noise
second: a dongle plugged straight into a
laptop sits in its USB noise field, and a
short extension lead is the standard cure.
The frequency third: `rtl_fm -f 96.1` tunes
to 96.1 *Hz*, an empty place; the tools
want `96.1M` or the full `96100000`. Gain
last: automatic gain hunting, or a fixed
value at either extreme (next symptom).

## Symptom: one loud neighbour deafens everything

**Cause:** **overload**. A strong FM or TV
transmitter near your antenna can fill the
8-bit converter's range by itself; every
weaker signal in the slice quantises into
nothing. The spectrum picture (chapter 8)
shows one tower standing in a flattened
landscape. Fixes are subtractive: *less*
gain, not more; the antenna moved or
shortened for that band; and for the FM
band specifically, a notch filter between
antenna and dongle is a standard accessory.
An LNA makes this failure worse, never
better — it amplifies the neighbour too.

## Symptom: a decoder runs, exits 0, decodes nothing

```
$ dump1090-mutability --ifile modes1.bin
...
Normal exit.
[exit 0]
```

**Cause:** the contract between the samples
and the decoder is broken, and a decoder
that finds no recognisable frames has
nothing to complain about — the sky it was
shown genuinely contains no decodable
frames *at the rate and format it assumed*.
Chapter 5 is this failure, captured: a
2.0 MHz recording met a decoder that
assumes 2.4 MHz. The live relatives: a
centre frequency set just off the signal,
a ppm error larger than the signal is wide
(next symptom), the wrong sample format
(`--iformat`), or a file of demodulated
*audio* where I/Q was expected — an easy
mistake, since both are "recordings from
the radio." Diagnose by feeding the chain a
known-good recording (recipe 1): if the
reference decodes, the chain is healthy
and the input is the suspect.

## Symptom: stations land offset, or drift as the dongle warms

**Cause:** ppm error (chapter 4). A plain
crystal's error grows with the dongle's
temperature, so a receiver can start an
evening correct and wander. Measure with
`rtl_test -p` against a signal of known
frequency, apply the number as `-p` /
`--ppm` to the tools, and treat the TCXO
dongle as the permanent fix. Wide signals
(ADS-B, FM) forgive tens of ppm; narrow
voice and data channels do not — a signal
can be inside your window at switch-on and
outside it by the time you find it.

## Symptom: dropouts, stutter, rtl_test reporting lost bytes

**Cause:** the stream outruns the machine.
Above ≈ 2.4 Msps sustained, the dongle and
a shared USB bus drop samples, and a
decoder fed a stream with holes stutters
or underruns. Lower the sample rate to
what the signal actually needs (a voice
channel is kilohertz wide; chapter 4's
arithmetic is the budget), give the dongle
its own USB port rather than a busy hub,
and let the computer be bored — SDR at
these rates is a light load only when the
rate is honest.

## Symptom: rtl_433 hears nothing for hours

**Cause:** usually the sky, not the setup.
Sensors transmit in seconds-long bursts
separated by long silences, and a street
can be quieter than it looks. Then the
checkables: the band centre for your
region (433.92 MHz is the default, not a
universal — chapter 6), and the antenna's
length for that band (17.3 cm is the
quarter-wave at 433.92 MHz; the stub that
was right for aircraft is a compromise
here). Verify the chain end-to-end with
something that transmits on demand and is
yours — a weather station of your own, or
your own car's key fob pressed beside the
antenna — before concluding the street is
silent.
