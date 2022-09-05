# normalize-branch-name Github Action

Extract the branch name from the GitHub runner context and normalize it using the following steps. Calculates the SHA1 checksum of the normalized branch name and truncates it to 8 characters length. The outputs are safe to use as ressource identifiers, e.g. as Docker container name.

### Output xample

```
Original branch name: fix/server/bug-ticket-#234
Normalized branch name: fix-server-bug-ticket-234
Branch name SHA1 checksum: 0ecaf4e1f58b0fc5c331bc6500e77f6a325bbb3d
Branch name short SHA1 checksum: 0ecaf4e1
```

### Normalization steps:

1. Remove all non-alphanumeric characters at the beginning of the string.
2. Replace slashes by dashes.
3. Remove trailing dashes.
4. Delete all characters other than `[a-zA-Z0-9-]`.
5. Truncate to 64 characters.

## Inputs

### `ref` **(required)**

Pass `${{ github.ref }}`.

### `head-ref`

Pass `${{ github.head_ref }}`.

## Outputs

### `original_name`

The original branch name.

### `name`

The normalized branch name.

### `hash`

SHA1 checksum of the normalized branch name.

### `short_hash`

SHA1 checksum of the normalized branch name, truncated to 8 characters.

## Usage example

```yml
on: push

jobs:
  normalize-branch-name-example:
    runs-on: ubuntu-latest
    steps:
      - name: Normalize branch name
        id: git-branch-name
        uses: ohueter/normalize-branch-name@main
        with:
          ref: ${{ github.ref }}
          head-ref: ${{ github.head_ref }}
      - name: Print normalized branch name and checksum
        run: |
          echo "Original branch name: ${{ steps.git-branch-name.outputs.original_name }}"
          echo "Normalized branch name: ${{ steps.git-branch-name.outputs.name }}"
          echo "SHA1 checksum of branch name: ${{ steps.git-branch-name.outputs.hash }}"
          echo "Short SHA1 checksum of branch name: ${{ steps.git-branch-name.outputs.short_hash }}"
```

Inspired by https://github.com/ankitvgupta/ref-to-tag-action.
