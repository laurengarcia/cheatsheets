# Hash Maps & Sets

## Hash Maps

An array answers “what’s at position i?” A hash map answers “what’s stored under this name?”

A **hash function** turns the key into a number, like 'lodash' → 7342, and that number picks a slot. So you get the array’s direct jump, O(1), but keyed by name instead of position.

**Real world:** this has been exploited. A hash-flooding attack sends a server thousands of keys crafted to collide, like JSON field names or query parameters, and turns every lookup into O(n). The request handler slows to a crawl, and that’s a denial of service. Node and V8 defend against it by randomizing the hash seed each time the process starts, so attackers can’t predict which keys collide; it’s a real case where a complexity worst case turned into a security issue.

In V8, due to collisions, the key is stored next to the value as a pair. Each entry is really `{ key: 'lodash', value: … }`. So the full lookup for `map.get('lodash')` is:

1. Hash 'lodash', which gives locker 7342.
2. Walk the entries there, comparing each stored key to 'lodash'.
3. Return the value from the entry whose key matches.

When to reach for a hash map: any time you catch yourself thinking “have I seen this?”, “how many times has this appeared?”, or “what goes with this name?” It’s the most common way to turn an O(n²) brute force into O(n).

## Sets

A `new Set` is the same machine with keys and no values.
It only answers “is this in here?”
