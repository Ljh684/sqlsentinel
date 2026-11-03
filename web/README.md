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
does not send SQL or findings over the network.
