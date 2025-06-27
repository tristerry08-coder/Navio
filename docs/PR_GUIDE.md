# Pull Request Guidelines

This document gives some guidelines to write and review PR with essential elements.

## Writing a Pull Request (PR):

- A PR should have a reasonable size and reflect only one idea, a feature, a bugfix, or a refactoring, to help review and limit regression in the app
- If a PR implements two different features, refactoring, or bug fixes, we prefer you to split it into several PRs
- New functionality and unit or integration tests for it should be developed in the same PR
- Every commit of all PRs should be compilable under all platforms. All tests should pass. So if changing of code breaks unit or integration tests these tests should be fixed
- Every commit should reflect a completed idea and have an understandable comment. Review fixes should be merged into one commit
- All commits and PR captions should be written in English.
- We suggest PRs should have prefixes in square brackets depending on the changed subsystem. For example, [routing], [generator], or [android]. Commits may have several prefixes (See `git log --oneline|egrep -o '\[[0-9a-z]*\]'|sort|uniq -c|sort -nr|less` for ideas.)
- Use imperative mood in commit's message, e.g. `[core] Fix gcc warnings` not `[core] Fixed gcc warnings`
- When some source files are changed and then some other source files based on them are auto-generated, they should be committed in different commits. For example, if you change style (mapcss) files, then put auto-generated files into a separate [styles] Regenerate commit
- All code bases should conform to ./docs/CPP_STYLE.md, ./docs/OBJC_STYLE.md, ./docs/JAVA_STYLE.md or other style in ./docs/ depending on the language
- The description field of every PR should contain a description to explain **what and why** vs. how.
- If your changes are visual (e.g. app UI or map style changes) then please add before/after screenshots or videos.
- Link Codeberg issues into the description field, [See tutorial](https://forgejo.org/docs/latest/user/linked-references/)

## Review a Pull Request (PR):

- All comments in PR should be polite and concern the PR
- It's better to ask the developer to make the code simpler or add comments to the codebase than to understand the code through the developer's explanation
- If a developer changes the PR significantly, the reviewers who have already approved the PR should be informed about these changes
- A reviewer should pay attention not only to the code base but also to the description of the PR and commits
- We prefer PRs to be approved by at least two reviewers. To have a different vision about how the feature/bugs are implemented or fixed, to help to find bugs and test the PR
- If a reviewer doesn't have time to review all the PR they should write about it explicitly. For example, LGTM for android part
- If a reviewer and a developer cannot find a compromise, a third opinion should be sought
- A PR which should not be merged after review should be marked as a draft.

## Recommendations:

- Functions and methods should not be long. In most cases, it's good if the whole body of a function or method fits on the monitor. It's good to write a function or a method shorter than 60 lines
- If you are solving a big task it's worth splitting it into subtasks and developing one or several PRs for every subtask.
- In most cases refactoring should be done in a separate PR
- If you want to refactor a significant part of the codebase, it's worth discussing it with all developers in an issue before starting work
- It's worth using the 'Resolve' conversation button to minimize the list of comments in a PR
