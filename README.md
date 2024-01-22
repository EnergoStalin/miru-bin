# Trigger with
```sh
curl \
  -X POST \
  -H "Authorization: Bearer <repo scoped token with write action permissions>" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/EnergoStalin/miru-bin/actions/workflows/aur.yaml/dispatches \
  -d '{"ref":"master"}'
```

# Required action secrets
- AUR_SSH_PRIVATE_KEY (ed25519)
- AUR_USERNAME
- AUR_EMAIL
