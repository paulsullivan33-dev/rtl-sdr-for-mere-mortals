# Sensors and rtl_433

**Scope:** the other great listening post —
the licence-free sensor bands around
433 MHz, where weather stations, tyre
gauges and power meters chatter in the
open, and `rtl_433`, the decoder that
understands hundreds of their dialects.

## A band full of small talk

Not everything on the air is a broadcast
meant for you. The **ISM bands** — spectrum
set aside for industrial, scientific and
medical gadgets — carry the domestic
infrastructure talking to itself: the
weather station in a garden reporting to
its display, tyre-pressure sensors reporting
to a dashboard, a wireless doorbell, a
power meter, a pool thermometer, remote
controlled sockets. In Europe the centre of
this world is **433.92 MHz**; North America
adds 315 MHz and shares 915 MHz; Europe also
uses 868 MHz. The transmissions are short,
plain, and — with narrow exceptions —
unencrypted, because the devices are cheap
and the data is the weather.

Note the difference from chapter 5's band,
because it shapes the ethics too: ADS-B is
broadcast *for* anyone listening. Sensor
traffic is transmitted in the open but
addressed to its owner's display. Receiving
it is the premise of the tool and a normal
part of the hobby; the line from chapter 1
still holds — you are hearing devices, not
people's private communications, and what
you do with a neighbour's thermometer
reading should stay as trivial as the
reading itself.

## rtl_433: one decoder, hundreds of dialects

`rtl_433` began as a 433 MHz decoder and
became a general one. The build machine's
copy states its version and its inputs in
its banner:

```
$ rtl_433
rtl_433 version 23.11 (2023-11-28) inputs file rtl_tcp RTL-SDR SoapySDR
[SDR] No supported devices found.
[exit 2]
```

Its defaults are in its captured help:
receive frequency **433920000 Hz**, sample
rate **250000 Hz** — a stethoscope, not a
survey window, because a sensor burst is a
few kilohertz wide and the decoder would
rather stare at one band centre for hours.
Its protocol table is the honest measure of
the project's scope:

Check: the list is the tool's own, and the
count was taken from it, not from the
project's web page:

```
$ rtl_433 -R help
rtl_433 version 23.11 (2023-11-28) inputs file rtl_tcp RTL-SDR SoapySDR
                = Supported device protocols =
    [01]  Silvercrest Remote Control
    [02]  Rubicson, TFA 30.3197 or InFactory PT-310 Temperature Sensor
    [03]  Prologue, FreeTec NC-7104, NC-7159-675 temperature sensor
    [04]  Waveman Switch Transmitter
...
244 numbered protocols in all (counted in the build's capture)
```

Two hundred and forty-four dialects, each
reverse-engineered from a real gadget's
transmissions by somebody who owned the
gadget. With a dongle, the workflow is the
simplest in this guide: run `rtl_433`, wait,
and read events as devices report in —
temperature, humidity, pressure, wind, rain,
battery state, each tagged with the sensor's
self-chosen ID and the protocol that made
sense of it. Options select frequencies
(beyond 433.92, with `-H` hopping between
several), restrict protocols (`-R`), and
shape output, including JSON for piping
into logs and dashboards. All of that is
this chapter describing a workflow it could
not run: the build machine has no dongle,
and no sensor obligingly transmitted into
a sandbox.

## What the file mode proves, and what it doesn't

`rtl_433` also reads recordings (`-r`),
which the build machine could exercise:

Check: the lab's aircraft recording — real
RF samples, entirely the wrong protocol —
fed to the sensor decoder:

```
$ rtl_433 -r modes1.bin
rtl_433 version 23.11 (2023-11-28) inputs file rtl_tcp RTL-SDR SoapySDR
[Input] Test mode active. Reading samples from file: samples/modes1.bin
[no decodes followed]
```

That is a complete, honest result. The file
path works; the analysis ran; and 217
aircraft messages decode to exactly nothing
here, because a decoder is a set of
expectations about pulse shapes and packet
grammar, and Mode S meets none of
`rtl_433`'s. It is chapter 5's lesson viewed
from the other side: **the same samples are
signal or silence depending on the decoder
you bring.** When your live `rtl_433` sits
quiet, the suspects, in order, are the
antenna's length for the band (chapter 2's
arithmetic: a quarter-wave at 433.92 MHz is
17.3 cm, not the ADS-B stub), the band
itself (is this gadget's frequency one you
are watching?), and only then the tool.

## Why this chapter matters to the rest

Between them, chapters 5 and 6 are the
dongle's two canonical jobs, and they bookend
the hobby's range: one signal engineered
for strangers to decode, with a published
grammar and a flagship tool; the other a
crowd of undocumented whispers that a
community decoded device by device. The
skills transfer intact — frequency,
bandwidth, sample rate, gain, patience —
and so does the discipline: state what you
verified, and what you only read about.
