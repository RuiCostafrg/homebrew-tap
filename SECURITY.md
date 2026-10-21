# Security policy

Only RuiCostafrg maintains this tap. Report bugs and requests through issues;
pull requests are restricted to collaborators. Security vulnerabilities should
be reported privately via the repository Security tab.

The sync workflow only accepts a strictly newer stable release from
RuiCostafrg/typescript-crap. It verifies the formula’s attestation against the
source repository, release workflow, tag and commit on a read-only runner.
Opening an automated update PR requires owner approval in the `homebrew` environment and uses only
a temporary GITHUB_TOKEN scoped to this repository. The write job treats the
formula as data and never executes it. Runtime installation tests happen in
separate read-only jobs. There are no long-lived publishing secrets.

Main requires owner-reviewed PRs and passing workflow/install checks. Neither the
Actions token nor automation can bypass main protection. The owner can bypass the
independent-review rule only through a PR because a sole maintainer cannot approve
their own PR. The protected publisher has contents, pull-requests and actions write
permissions solely to create an update branch/PR and dispatch read-only CI. The
owner merges after checks pass. The owner controls settings and remains a trust root.
