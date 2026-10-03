# Wallpaper media and Git LFS

This repository is the source of truth for the curated wallpaper collections:

- `wallpapers/` for static wallpapers
- `video-wallpapers/` for video wallpapers

Both directories are tracked with Git LFS so large binary files do not live directly in normal Git history.

## Fresh install behavior

`git-lfs` is installed from `packages/base.txt` during the base bootstrap.

Because the repository may have been cloned before `git-lfs` was installed, `install/media.sh` runs:

```bash
git lfs install --local
git lfs pull
```

before copying media into the normal user folders:

```text
wallpapers/       -> ~/Pictures/Wallpapers/
video-wallpapers/ -> ~/Videos/
```

This ensures a fresh Arch install receives the real media files rather than Git LFS pointer files.

## Updating the repository from the current desktop

When new wallpapers have been added to the local desktop folders, run:

```bash
bash scripts/sync-media.sh
```

The script copies:

```text
~/Pictures/Wallpapers/ -> wallpapers/
~/Videos/              -> video-wallpapers/
```

It uses `rsync -r` and intentionally does not delete files from the repository. The repo remains the long-term fallback/source of truth.

Review the result before committing:

```bash
git status
```

Then commit and push normally:

```bash
git add wallpapers video-wallpapers
git commit -m "Update wallpapers"
git push
```

The `.gitattributes` rules automatically route files in those directories through Git LFS. Normal updates do not require manually running `git lfs track` or `git lfs push`.

## Useful checks

Show files currently managed by Git LFS:

```bash
git lfs ls-files
```

Verify local LFS objects:

```bash
git lfs fsck
```
