# Playground Deployment

The static playground is committed under `web/dist/`. GitHub Pages must be
enabled once by a repository administrator:

1. Open the repository **Settings → Pages**.
2. Set **Build and deployment → Source** to **GitHub Actions**.
3. Open **Actions → Deploy Playground → Run workflow**.

The workflow installs the pinned MoonBit toolchain, rebuilds the playground,
uploads `web/dist`, and deploys it to:

`https://ljh684.github.io/sqlsentinel/`

The workflow is intentionally manual while Pages is disabled. After Pages is
enabled, it can safely be changed to deploy on pushes to `main`.
