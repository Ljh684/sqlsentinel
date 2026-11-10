# SQLSentinel Browser Playground

Build the MoonBit scanner as an ES module and assemble a static demo:

```bash
moon build --target js --release web
mkdir -p web/dist
cp _build/js/release/build/web/web.js web/dist/
cp web/site/* web/dist/
python3 -m http.server 8080 --directory web/dist
```

Open <http://localhost:8080>. The scanner runs entirely in the browser: the page
does not send SQL, schema data, or findings over the network.

The Playground includes an editable schema catalog. Schema checks can be enabled
or disabled, JSON can be imported or formatted, and SQL201/SQL202 findings are
shown alongside the structural rules. The `scanSqlBundle` ES-module export
returns the JSON report, Markdown review packet, and an in-browser migration
plan from one scan. The page displays schema changes and SQL301–SQL304 semantic
findings without a server.
