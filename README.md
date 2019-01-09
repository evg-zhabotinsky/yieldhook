YieldHook
---------

This simple proof-of-concept library adds an extra letter to the mask parameter
of `debug.sethook` Lua function. If the mask contains the letter `'y'`, then
whenever the hook finishes and returns a true value the paused coroutine will
yield.

Note, however, that Lua only allows a C hook to yield without continuation
(i.e. in non-resumable manner) or any values, and only if it's the last
thing it does *and the event was either line or count*. This library only
exposes this feature to Lua code by means of a C hook function that calls
the provided Lua one and then yields if that returned a truth.
Therefore, `coroutine.resume` returns just `true` when the hook yields, and
attempts to yield when event is not `"line"` or `"count"` will be ignored.

This repository includes a simple test program that demonstrates preemptive
multitasking in pure Lua plus this small library. It runs in a single OS
thread, of course, since ANSI C has no threading facilities and therefore
pure Lua has none either.

The project is mostly inspired by Minecraft mod OpenComputers having no
preemptive multitasking, at the time of writing, to see if it can be fixed.

*P.S.:*
I actually tried to implement it myself at first, but then realized that I
could simply copy most of the code from Lua's debug library bindings. After
all, this library basically duplicats `debug.sethook` with only slight changes.

Building
--------

Run `make` to build the library itself.
Run `make test` to run the test program.

I only tested it with Lua5.3 on Linux. Specifically, Ubuntu 18.04 with
packages `build-essential`, `lua5.3` and `liblua5.3-dev` installed.

Usage
-----

Basically, do a `require('yieldhook')` and enjoy the
extra mask parameter and yieldable hooks.

Requiring this library is irreversible, as it modifies the `debug` table.

See `test.lua` for a complete usage example.

License
-------

Lua is MIT-licensed, therefore so is this library.

Copyright (c) 2019 Evgeniy Zhabotinskiy.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

