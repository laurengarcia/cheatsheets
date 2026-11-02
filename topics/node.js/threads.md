# Node.js Threads

## Single Thread = One Barista

Picture a coffee counter with one barista. That’s your JavaScript thread.

- She works on one order at a time, and she never stops mid-order. Whatever she starts, she finishes before looking up. This is called run-to-completion.
- Slow work (grinding beans, steaming milk) goes to machines. She starts the machine and moves on immediately. She doesn’t stand there waiting.
- When a machine finishes, it doesn’t interrupt her. It puts a ticket on the rail.
- Only when her hands are empty does she check the rail, take the next ticket, and run its callback to completion.

The rail-checking routine, repeated forever, is the event loop.

### Mapping it to Node

Barista                            Node.js
--                                 --
The barista’s current task stack   Call stack: the functions running right now
The machines                       libuv and the OS: sockets via the OS’s async APIs;
                                     fs, dns.lookup, crypto, and zlib via libuv’s thread pool
                                     4 threads by default
Tickets on the rail                Callback queues: callbacks waiting for the stack to empty
“Hands empty, check the rail”      The event loop


“Node is single-threaded” is only true for your JavaScript. Node as a whole uses several threads. Your code just never runs on two of them at once, which is why you rarely need locks.

The flip side matters: the barista can be hogged. If one order is a giant synchronous loop or a huge JSON.parse, every ticket on the rail waits, including ones that are “already done.” That’s what “blocking the event loop” means, and it’s behind a lot of “the server hangs randomly” tickets.

