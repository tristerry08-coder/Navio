# How works CI?

CI Codeberg is limited and cannot be used for now to build regularly apps and executes tests.
To limit regressions, we have enabled temporary Github CI on the [Github Mirror](https://github.com/comaps/comaps) to build Android and IOS app and execute linter each time we sync the mirror.

- [Android CI](https://github.com/comaps/comaps/actions/workflows/android-check.yaml)
- [IOS CI](https://github.com/comaps/comaps/actions/workflows/ios-check.yaml)
