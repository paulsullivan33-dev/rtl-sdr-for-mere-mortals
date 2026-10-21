# First Listening

**Scope:** installing the toolkit on the
three desktop systems, the census command
that proves the dongle is alive, and the
hobby's first command — broadcast FM through
`rtl_fm` — with the part of that chain that
needs no radio verified end to end.

## Installing

**Linux** is the native home of these tools.
On Debian and Ubuntu the whole userland is
one line:

```
$ sudo apt install rtl-sdr
```

That package brings the `rtl_*` family, the
library they share, and the udev rules that
let a non-root user open the device. Two
Linux wrinkles, both in chapter 9: the
kernel's own TV driver claims the dongle
first unless it is blacklisted
(`blacklist dvb_usb_rtl28xxu` in
`/etc/modprobe.d/`), and the library version
matters to the newest hardware (chapter 2).

**Windows** has no system package manager
tradition to lean on; the standard route is
prebuilt binaries plus **Zadig**, a small
tool that installs the WinUSB driver the
library needs in place of the TV driver
Windows assigns. Get the binaries from the
projects (Osmocom's Windows build pages),
run Zadig against the dongle's bulk-in
interface, and the same command-line tools
behave the same. The detail changes with
releases; the shape does not.

**macOS** gets the userland through Homebrew
(`brew install rtl-sdr`) or MacPorts, and
the tools run in the terminal the same way.

On the build machine the toolkit's presence
is a captured fact (chapter 1); its absence
of a dongle is equally captured, which is
why this chapter's radio commands are shown
as the tools themselves describe them, and
the audio half below is the part proven
live.

## The census: rtl_test

Every first session starts here:

```
$ rtl_test
```

On a machine with a dongle this prints the
device it found — tuner name, supported
gains — and then benchmarks sample loss
until you stop it. `rtl_test -t` runs the
tuner benchmark; `rtl_test -p` measures the
dongle's frequency error against a known
signal (chapter 4 needs that number).

Check: the same commands on the build
machine state their condition exactly, and
they are all this chapter can honestly show
of them:

```
$ rtl_test
No supported devices found.
[exit 1]
$ rtl_test -t
No supported devices found.
[exit 1]
```

Treat that message as the census returning
zero, not as an error to be feared. Chapter
9 works through what to check when it says
zero and shouldn't.

## Broadcast FM: rtl_fm

`rtl_fm` is a complete little receiver: it
tunes, demodulates, and hands you audio (or
raw samples) on standard output. Its full
option list is long; the build machine
captured it from the tool itself. The lines
that carry the first-listen command:

```
$ rtl_fm -x        (an invalid option — the reliable way to make rtl_fm print its usage)
rtl_fm, a simple narrow band FM demodulator for RTL2832 based DVB-T receivers

Use:    rtl_fm -f freq [-options] [filename]
        -f frequency_to_tune_to [Hz]
            use multiple -f for scanning (requires squelch)
            ranges supported, -f 118M:137M:25k
        [-M modulation (default: fm)]
            fm, wbfm, raw, am, usb, lsb
            wbfm == -M fm -s 170k -o 4 -A fast -r 32k -l 0 -E deemp
        [-s sample_rate (default: 24k)]
        [-g tuner_gain (default: automatic)]
        [-l squelch_level (default: 0/off)]
        [-p ppm_error (default: 0)]
filename ('-' means stdout)
```

The classic first command, piped into the
system's audio player, is:

```
$ rtl_fm -f 96.1M -M wbfm -s 170k -r 32k - | aplay -r 32000 -f S16_LE
```

Read it left to right: tune to 96.1 MHz;
demodulate wideband FM (`-M wbfm`, which the
usage text itself expands into the
narrowband demodulator sampling at 170k
with de-emphasis); resample the audio to
32k (`-r`); write signed 16-bit samples to
stdout; `aplay` plays them at the rate the
headerless stream cannot announce. Change
the frequency to a station you know is
strong where you live. What you should hear
is recognisable broadcast audio — rough at
the edges if the antenna is the telescopic
dipole indoors, but unmistakably a radio.

The single-letter options generalise, and
each is a chapter hook: `-g` fixes the gain
the automatic setting would otherwise hunt
with (chapter 4), `-l` is **squelch** — the
silence gate that makes scanning useful,
turning dead air into no output at all —
and multiple `-f` values turn the same
command into a scanner that walks, for
example, the 118–137 MHz airband in 25 kHz
steps with `-M am`. (Aviation voice is AM,
openly transmitted, and a standard second
stop on the tour.)

## The half of the chain that needs no radio

`rtl_fm`'s output is a headerless stream: it
has no way to say "I am 24 kHz mono." Tools
that consume it must be told, which is why
`aplay` above takes a rate and a format, and
why **sox** — the sound-file Swiss army
knife — is the hobby's standard label-maker.
This half was verified on the build machine
with a synthesised stand-in for `rtl_fm`'s
output, exactly the shape it emits:

Check: two seconds of an 880 Hz tone, made
as headerless 24 kHz signed 16-bit mono —
96,000 bytes, and the arithmetic is the
lesson (2 s × 24,000 samples × 2 bytes):

```
$ sox -n -t raw -r 24000 -e signed-integer -b 16 -c 1 synth-tone.raw synth 2 sine 880
$ ls -l synth-tone.raw
-rw-rw---- 1 root nogroup 96000 ... synth-tone.raw
$ sox -t raw -r 24000 -e signed-integer -b 16 -c 1 synth-tone.raw tone.wav
$ soxi tone.wav

Input File     : 'tone.wav'
Channels       : 1
Sample Rate    : 24000
Precision      : 16-bit
Duration       : 00:00:02.00 = 48000 samples
...
$ sox tone.wav -n stats
RMS lev dB     -6.05
Length s       2.000
```

So the workflow a reader will actually use —
demodulate to a raw file when the radio is
on, then label, trim, and measure it with
sox afterwards — is real, and runs today.
What remains undemonstrated is the radio in
front of it, and the guide does not pretend
otherwise: when your dongle is plugged in,
`rtl_fm -f ... -` writes exactly the stream
this chain just consumed.
