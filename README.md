# Moon Rabbit - gopher browser(version for ZX Spectrum-compatible machines)

## Important notice!

All traffic on MB03+ target goes currently via my personal proxy-server(it splits data by chunks and send it to your computer and don't make anything else). You can check proxy sources [here](https://github.com/nihirash/spectrum-next-gopher-proxy) 

I don't store any data but You should know about it.

But later I'll add possibility use your own proxy server without need to recompile sources. If it's very important for you - say me about it and I'll do it sooner. If you want change proxy to your own now - please edit file `proxy.asm` in `drivers` directory(just replace myown IP address with your). 

Why I did it? Cause MB03+'s uart doesn't have flow control and current ESP's firmware sends data to speccy as soon as it received without keeping it in buffer. So, sometimes it ends with data losing. To prevent data losing I did very small proxy that helps us to receive data.

## Development

To compile project all you need is [sjasmplus](https://github.com/z00m128/sjasmplus).

You may use or not use GNU Make. But GNU Makes allows make build easier.

For building version without GNU make you should execute: 

For MB03+:

```
sjasmplus main.asm -DPROXY -DMB03 -DGS -DTIMEX
```

For ZXUno:

```
sjasmplus main.asm -DUNO -DTIMEX
```

## Usage

Put on SD-card `moonr.bas`, `moon.bin` and `data/` directory to same level.

Make sure that you have preconnected ESP-module to wifi. Execute `moonr.bas` and enjoy.

Remark for ZX-Uno users: it requires enabled "new graphics modes"

~Remark for MB03+ users: I haven't real device. All development made in "blind" mode~

UPD: I've got it. It's really ultimate.

## Sponsorship

Github sponsorship isn't available for Russia.

You can support my work via PayPal(attached email written in [LICENSE file](LICENSE)).

Thank you.

## License

I've licensed project by [Nihirash's Coffeeware License](LICENSE).

Please respect it - it isn't hard.