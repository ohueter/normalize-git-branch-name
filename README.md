# normalize-branch-name Github Action

This action uses the Github context to extract the branch name and normalize it according to the following steps. It calculates the SHA1 checksum of the normalized branch name.

1. Remove all non-alphanumeric characters at the beginning of the string.
2. Replace slashes by dashes.
3. Remove trailing dashes.
4. Delete all characters other than `[a-zA-Z0-9-]`.
5. Truncate to 64 characters.w

## Inputs

### `ref`

**Required** Pass `${{ github.ref }}`.

### `head-ref`

Pass `${{ github.head_ref }}`.

## Outputs

### `original-name`

The original branch name.

### `name`

The normalized branch name.

### `hash`

SHA1 checksum of the normalized branch name.

## Example

```yml
on: push

jobs:
  normalize-branch-name-example:
    runs-on: ubuntu-latest
    steps:
      - name: normalize branch name
        id: git-branch
        uses: clarifydata/normalize-branch-name@v1
        with:
          ref: ${{ github.ref }}
          head-ref: ${{ github.head_ref }}
      - name: Get normalized branch name and checksum
        run: |
          echo "Original branch name: ${{ steps.git-branch.outputs.original_name }}"
          echo "Normalized branch name: ${{ steps.git-branch.outputs.name }}"
          echo "SHA1 checksum of branch name: ${{ steps.git-branch.outputs.hash }}"
```

Inspired by https://github.com/ankitvgupta/ref-to-tag-action.
