# Web Components & htmx

## Web Components
Vanilla html components. No build pipelines.
Better for writing isolated, reusable components.
State management still TBD tho unless you use a wrapper framework.
Has own shadow-dom implementation for perf.
Will likely outlast all frameworks in the end.

Web components communicate with the surrounding page by dispatching custom events through their root element which makes them a natural fit for hypermedia-friendly scripting.

Arguments for:
- https://jakelazaroff.com/words/web-components-will-outlive-your-javascript-framework/

Examples:
- https://github.com/mdn/web-components-examples

Docs:
- https://developer.mozilla.org/en-US/docs/Web/API/Web_Components

Frameworks that compile to web components:
Lit, Stencil, Svelte


## htmx
Embeds neatly into html/ web components via `hx-` attributes.
For "Hypermedia Driven Application" (the anti-SPA)
Technically its a library not a framework.

Synchronizes state with a server.

Interacts with the server in terms of hypermedia (i.e. HTML) than a non-hypermedia format (e.g. JSON). The interaction with the server is done via HTTP and HTML: an HTTP POST request is sent to the server, HTML is returned by the server and htmx inserts this HTML into the DOM

Not fully built-out or stabilized as of 10/2023.

Docs:
- https://htmx.org/docs/

"Hypermedia-friendly scripting":
- https://htmx.org/essays/hypermedia-friendly-scripting/

Examples:
- https://htmx.org/examples/
