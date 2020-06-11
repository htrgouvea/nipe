# Contributing to the Nipe!

## Branches

The `master` branch is used only for holding released code of the project. Any
new feature or bugfix **must** be opened against `develop` branch, where some
additional testing is performed before the code lands `master`.

## Testing

For every new feature, please, submit in the same PR a testing code (under
`t/` folder) to cover that completely. Make sure to expand and cover the
added/replaced code as much as possible.

In case it's a functional bugfix (not a typo, commentary, whitespace, ...
issue), make sure to check why the test code didn't trigger the bug before
and, if possible, update the test.

## Great Re-Writings

Open a discussion issue before you begin. So we can listen to what you have to
say, and we can provide a referral if it will be worth changing big parts of
the project.

## License

By opening a pull request in this repository, you agree to provide your work
under the [project license](../LICENSE.md).
