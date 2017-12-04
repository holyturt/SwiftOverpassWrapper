# SwiftOverpassWrapper

This library aims to make a query for the Overpass API easily in Swift.

## Usage
Let's say this is a Overpass XML collects nodes which have the key "name" that equals the value "Gielgen":
```xml
<osm-script>
  <query type="node">
    <has-kv k="name" v="Gielgen"/>
    <bbox-query e="7.25" n="50.8" s="50.7" w="7.1"/>
  </query>
  <print/>
</osm-script>
```
can be written like:
```swift
#import SwiftOverpass

let query = SwiftOverpass.query(type: .node)
query.setBoudingBox(s: 50.7, n: 50.8, w: 7.1, e: 7.25)
query.hasTag("name", equals: "Gielgen")

SwiftOverpass.api(endpoint: "http://overpass-api.de/api/interpreter")
	.fetch(query) { (response) in
		// do whatever you want
	}
```

## Example
Overpass Xml:
```xml
<union>
  <query type="node">
    <has-kv k="name" v="Schloss Neuschwanstein"/>
  </query>
  <recurse type="node-relation"/>
</union>
<print/>
```

Swift:
```swift
let nodeQuery = SwiftOverpass.query(type: .node)
nodeQuery.hasTag("name", equals: "Schloss Neuschwanstein")
let relationQuery = nodeQuery.related(.relation)

SwiftOverpass.api("http://overpass-api.de/api/interpreter")
	.fetch([nodeQuery, relationQuery]) { (response) in
    // do whatever you want
  }
```

---

### License

This software is freely distributable under the MIT License.
