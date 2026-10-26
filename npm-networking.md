# NPM Networking

## Conventions

`HTTPS_PROXY` and `NO_PROXY` are env vars, can be set in a number of places

Where they get set, from narrowest to broadest:

1. One command: `HTTPS_PROXY=http://proxy.acme.com:8080 npm install`
2. The shell: an export `HTTPS_PROXY=...` line in ~/.zshrc or ~/.bashrc, applied to every terminal you open.
3. System-wide: IT pushes them through device mgmt, or files like /etc/environment on Linux.
4. CI/CD: in the pipeline config.

Tool-specific config can override or ignore them:

- npm reads the env vars, but also has its own `proxy`, `https-proxy`, and `noproxy` settings in `.npmrc`. That file can exist per-project, per-user, or globally, and npm merges them in an order of precedence.
- git has its own `http.proxy` setting.
- curl reads lowercase `http_proxy` but deliberately ignores uppercase `HTTP_PROXY`, for a security reason. Uppercase and lowercase both work for `HTTPS_PROXY`.
- Core Node historically ignored these variables entirely, unless the app used a proxy-aware library. Newer versions have opt-in support. So a Node-based CLI may or may not honor them, depending on how it was built.

## Troubleshooting

### Problem 1:
`npm install` works fine at home but fails at an office with `self signed certificate in certificate chain`.

**Root Cause:**
At office: a TLS-inspecting proxy (Zscaler, Palo Alto, Netskope, and similar) is in place at perimeter of firewall. Company security wants to scan encrypted traffic for malware and data leaks. So the proxy deliberately does a man-in-the-middle:
- Your machine asks for registry.npmjs.org.
- The proxy intercepts, opens its own connection to the real registry, and decrypts the traffic.
- It hands your machine a fake certificate for registry.npmjs.org, freshly signed by the company’s own root CA.

A TLS certificate is like a passport. Your browser doesn’t trust the passport itself; it trusts whoever issued it. Every chain ends at a root issuer, and a root signs its own certificate, since there’s no one above it to vouch. So every root cert is self-signed. That’s fine as long as the root is on your client’s list of trusted issuers. IT pushes that company root into the operating system’s trust store on every work laptop, so Chrome and Safari see a valid chain and stay quiet.

But Node breaks: by default, Node doesn’t use the OS trust store. It ships its own bundled list of public root CAs. So Node walks the chain, hits the company root, finds it on no list, and reports a self-signed certificate in the chain. That’s technically true: the root is self-signed and untrusted. At home there’s no proxy, so you get the real cert and everything works.

The fixes, from best to worst:

1. NODE_EXTRA_CA_CERTS=/path/to/corp-root.pem adds the company root to Node’s list.
2. npm config set cafile /path/to/corp-root.pem does the same for npm specifically.
Recent Node versions also have an option to trust the OS store directly, which is worth checking in the docs.
3. strict-ssl=false or NODE_TLS_REJECT_UNAUTHORIZED=0 turns off verification entirely. This is the wrong answer, never recommend it.

To confirm: `openssl s_client -connect registry.npmjs.org:443 -showcerts`
Look at CA issuer; If it says something like “Acme Corp Root CA” instead of a public CA, you’ve found your proxy.


### Problem 2:
A diff corp office has set `HTTPS_PROXY` correctly, but `npm install` still hangs, and only for packages from their internal Artifactory registry, `artifactory.corp.internal`. Public packages install fine.

**Root Cause:**
The proxy sits at the edge of Acme’s network, facing out toward the internet. Artifactory sits inside, next to the developers. `HTTPS_PROXY` tells npm to send every HTTPS request to the proxy, with no exceptions. So npm routes the internal request out to the edge, and the proxy is asked to find `artifactory.corp.internal`.

But often it can’t. Internal names usually resolve only on internal DNS (that’s split-horizon DNS), or the proxy has no route back into that network segment. So the request goes nowhere, and npm waits until it times out. Silence means the traffic was sent somewhere that never answers. When you hear “it hangs,” think “routed somewhere wrong or silently dropped,” not “rejected.”

`NO_PROXY=artifactory.corp.internal`, or `.corp.internal` with a leading dot to cover the whole internal domain. npm also has its own noproxy config. This says: “talk to these hosts directly, skip the proxy. this destination is local, go straight there.”

How to confirm:

- `npm install --verbose` shows which proxy each request is going through.
- `curl -v https://artifactory.corp.internal` hangs, but `curl -v --noproxy '*' https://artifactory.corp.internal` connects.
