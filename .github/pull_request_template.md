# Pull Request

For all pull requests, make sure you have done a `git pull` and have no merge conflicts.

## Checklist before requesting a review
- [ ] I have performed a self-review of my code
- [ ] I will assign a reviewer
- [ ] I have checked that these features are not already integrated (doc or previous PR).


### Packages

- [ ] I have updated the documentation accordingly and run `devtools::document` 
- [ ] I have commented critical sections of the code
- [ ] I have added tests to cover my changes.
- [ ] `R CMD check` runs without warnings or errors and any notes have been checked.
- [ ] All new and existing tests are passed.
- [ ] I have updated the version to be higher than the `main` branch version.
