# Security policy

Only RuiCostafrg maintains this tap. Report bugs and requests through issues;
pull requests are restricted to collaborators. Security vulnerabilities should
be reported privately via the repository Security tab.

The sync workflow only accepts a strictly newer stable release from
RuiCostafrg/typescript-crap. It verifies the formula’s attestation against the
source repository, release workflow, tag and commit on a read-only runner.
Publishing requires owner approval in the `homebrew` environment and uses only
a temporary GITHUB_TOKEN scoped to this repository. The write job treats the
formula as data and never executes it. Runtime installation tests happen in
separate read-only jobs. There are no long-lived publishing secrets.

Protect main against deletion/force pushes. Only the owner and the GitHub Actions
integration may bypass the tap PR rule; Actions uses this exception only after
environment approval. The owner controls settings and remains a trust root.
