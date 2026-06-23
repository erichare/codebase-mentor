# onboarding/

ONBOARDING.md files for each target repository, maintained here and synced to the repo root.

## Structure

```
onboarding/
├── <repo-name>/
│   └── ONBOARDING.md   ← authoritative copy
└── README.md           ← this file
```

The folder name matches the GitHub repository name. The `ONBOARDING.md` inside is the
authoritative copy — edit here, then sync outward.

## Repos

| Folder | Repo | GitHub |
|---|---|---|
| `stargate-jsonapi/` | Stargate Data API (reference implementation) | https://github.com/stargate/jsonapi |
| `astrapy/` | AstraPy Python client | https://github.com/datastax/astrapy |
| `langflow/` | Langflow visual workflow builder | https://github.com/langflow-ai/langflow |

## Syncing to a repo

Copy the file to the root of the target repo:

```bash
# astrapy
cp onboarding/astrapy/ONBOARDING.md ~/GitHub/astrapy/ONBOARDING.md

# langflow
cp onboarding/langflow/ONBOARDING.md ~/GitHub/langflow/ONBOARDING.md

# stargate-jsonapi
cp onboarding/stargate-jsonapi/ONBOARDING.md ~/GitHub/jsonapi/ONBOARDING.md
```

Or use `rsync` for a one-liner that only copies when the source is newer:

```bash
rsync -av --update onboarding/astrapy/ONBOARDING.md ~/GitHub/astrapy/ONBOARDING.md
rsync -av --update onboarding/langflow/ONBOARDING.md ~/GitHub/langflow/ONBOARDING.md
```

## Adding a new repo

1. Create `onboarding/<repo-name>/`
2. Copy [`../template/ONBOARDING.md`](../template/ONBOARDING.md) into it and fill in all sections using
   the [`../template/AUTHORING_GUIDE.md`](../template/AUTHORING_GUIDE.md)
3. Add a row to the table above
4. Sync to the repo root
