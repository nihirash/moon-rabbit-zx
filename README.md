# Moon Rabbit - gopher browser(version for ZX Spectrum-compatible machines)

## Development

To compile project all you need is [sjasmplus](https://github.com/z00m128/sjasmplus).

You may use or not use GNU Make. But GNU Makes allows make build easier.

For building version without GNU make you should execute: 

For MB03+:

```
sjasmplus main.asm -DPROXY -DMB03 -DTIMEX
```

For ZXUno:

```
sjasmplus main.asm -DUNO -DTIMEX
```

## Usage

Put on SD-card `moonr.bas`, `moon.bin` and `data/` directory to same level.

Make sure that you have preconnected ESP-module to wifi. Execute `moonr.bas` and enjoy.

Remark for ZX-Uno users: it requires enabled "new graphics modes"

Remark for MB03+ users: I haven't real device. All development made in "blind" mode.

## Sponsorship

Github sponsorship isn't available for Russia.

You can support my work via PayPal(attached email written in [LICENSE file](LICENSE)).

Thank you.

## License

I've licensed project by [Nihirash's Coffeeware License](LICENSE).

Please respect it - it isn't hard.