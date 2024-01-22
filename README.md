# Trigger with
```sh
curl \
  -X POST \
  -H "Authorization: Bearer <repo scoped token with write action permissions>" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/EnergoStalin/miru-bin/actions/workflows/83218120/dispatches \
  -d '{"ref":"master"}'
```

# To get workflow id
```sh
curl \
  -X GET \
  -H "Authorization: Bearer <token>" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/EnergoStalin/miru-bin/actions/workflows
```

# Required action secrets
- AUR_SSH_PRIVATE_KEY
- AUR_USERNAME
- AUR_EMAIL