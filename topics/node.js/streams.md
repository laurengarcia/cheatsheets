# Node.js Streams

## There are 4 Types of streams:

Analogy: streams are like a hose of data

| Type        | Direction          | Examples                                   |
|---          |---                 |---                                         |
| Readable    | "water" comes OUT  | fs.createReadStream, req, process.stdin    |
| Writable    | "water" goes IN    | fs.createWriteStream, res, process.stdout  |
| Duplex      | both, independent  | a TCP socket                               |
| Transform   | in → changed → out | zlib.createGzip()                          |


## Example

Count the number of lines in a log file:

```js
const text = await fs.promises.readFile('access.log', 'utf8');
const lines = text.split('\n').length;
```
Issues with this:
- `fs.readFile` refuses files over 2 GiB: RangeError [ERR_FS_FILE_TOO_LARGE]
- Even under 2 GiB, the 'utf8' conversion must fit in one JS string, and V8 caps strings at ~512MB of characters: ERR_STRING_TOO_LONG
- "Worked for months, then crashed" = the file slowly grew past a fixed limit

Why the stream version works:
- It reads the file in chunks (64KB each for fs.createReadStream)
- Memory depends on chunk size, not file size

The stream version that would work:
```js
let lines = 0;
// Readable streams are async iterable, so `for await` works:
for await (const chunk of fs.createReadStream('access.log')) {
  for (const byte of chunk) if (byte === 10) lines++;   // 10 = '\n'
}
```


## Backpressure

What if water comes in faster than the far end can take it out? Say you read from a fast disk and write to a slow network client. Without some kind of control, the extra water has to go somewhere, so it builds up in a buffer in memory.

Backpressure is the far end saying “slow down.” In Node it looks like this:
- `writable.write(chunk)` returns `false` when the writable’s internal buffer is full (past its `highWaterMark` - 64KB by default in Node 22+, 16KB on older versions).
- `highWaterMark` is NOT a cap. Past it, `write()` still accepts and buffers the chunk; it just returns `false`. Ignore the `false` and the whole file ends up buffered in memory (a slow client downloading a 4GB ISO = up to 4GB of RAM for one request).
- That’s your signal to stop writing until the writable emits 'drain', meaning its buffer has emptied and you can continue.

Implement by hand, so you can see how it works:
```js
const src = fs.createReadStream('big.iso');   // fast disk

src.on('data', chunk => {
  if (!res.write(chunk)) {                 // buffer full: "slow down"
    src.pause();                           // stop reading from disk
    res.once('drain', () => src.resume()); // continue when it empties; attaches a one-time listener
  }
});

src.on('end', () => res.end());
```

Actual shipped code for the above would be:
```js
const { pipeline } = require('node:stream/promises');
// pipeline does the pause/drain logic for you
// also handles errors and cleanup for every stream in the chain
// in real code, this would inside an async request handler since `require` syntax doesn't allow top-level await
await pipeline(fs.createReadStream('big.iso'), res);
```
- `stream.pipeline` was added in Node 10 (2018)
- the promise version (node:stream/promises) in Node 15
- `pipeline` is a port of mafintosh's `pump` npm module bc original `.pipe()` impl didnt clean up on errors
- its companion module `end-of-stream` became `stream.finished`
- `pipeline` also destroys every stream in the chain if any stream in the chain errors or closes early


## Why not `src.pipe(res)`?
- `.pipe()` handles backpressure but NOT cleanup. If the client disconnects mid-download, `res` is destroyed but `src` stays open, leaking a file
descriptor. Files and sockets share the per-process fd limit (`ulimit -n`), so after enough dropped downloads:
```text
Error: EMFILE: too many open files    (new files AND new connections fail)
```
Check a live process: `ls /proc/<pid>/fd | wc -l` (Linux) or `lsof -p <pid>`
