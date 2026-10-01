# Source release procedure

`VERSION` is the source version. Breaking ownership changes increment MAJOR;
minor additive behavior increments MINOR and compatible fixes increment PATCH.
Keep README, CHANGELOG and the release title aligned with it.

1. Fetch origin and start `vMAJOR.MINOR.PATCH` from current main in the existing
   checkout. Create matching GitHub issue and milestone; reference the issue.
2. Implement, run `bash tests/all.sh` and `git diff --check`, obtain independent
   review, and open a PR into main. Record actual validation and limitations.
3. Resolve findings and wait for required CI. Merge the reviewed PR, then update
   local main with a fast-forward and verify the merged SHA.
4. Tag that SHA with an annotated immutable matching version, push the tag, and
   create a non-draft GitHub release from it. GitHub source archives are the
   distribution assets; this repository has no npm/Python package publication.
5. Verify release tag/target, main synchronization, clean checkout, issue and
   milestone closure. Preserve published version branches as historical records.

No host export/install or ASDS/DSH change is implied. Do not create alternate
installations, runtime staging copies or backups. Tests may use self-cleaning
fixture directories, never alternate active installations. Existing unrelated
user directories are not release residue and must not be deleted.
