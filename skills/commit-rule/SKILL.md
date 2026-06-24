---
name: commit-rule
description: >-
  Use this skill when writing, reviewing, rewriting, or executing Git commits
  that must follow a scoped title, a required body, mandatory Signed-off-by
  trailers, and gitlint-compatible title rules such as "area: Summary" with an
  uppercase summary.
---

# Git Commit Rule

Use this skill when the user asks for a commit message, commit rule review,
commit title/body cleanup, gitlint-compatible commit message, or a `git commit`
command.

The target style is repository-agnostic. It is based on a scoped title, a
non-empty explanatory body, and a mandatory `Signed-off-by:` trailer. When
creating a commit with Git, always use `git commit --signoff` or `git commit -s`
so Git appends the sign-off from the local Git identity.

## Required format

Write commit messages in this shape:

```text
area: Optional nested area: Summary starting with an uppercase letter

Explain what changed and why it changed. Include enough context for reviewers to
understand the intent without reading the entire diff. Mention important design
choices, assumptions, limitations, or verification details when relevant.

Signed-off-by: Full Name <email@example.com>
```

The `Signed-off-by:` trailer is always required. Do not return a final commit
message without it.

When the user's name and email are known from the current task context, use them.
When they are not known, use a placeholder in the message draft or recommend
creating the commit with `git commit --signoff` so Git fills the trailer from the
local Git configuration.

The title must match this gitlint rule:

```ini
[general]
regex-style-search=true

[ignore-body-lines]
regex=^(?:(?:Signed-off|Acked|Co-Authored|Reported|Tested)-by: |\[\d+\]: https:\/\/)

[title-match-regex]
regex=^(([a-z0-9._-]+: )+)?[A-Z].*
```

## Git command rules

When suggesting or executing a commit command, always include `--signoff` or
`-s`.

Preferred command shape:

```bash
git commit --signoff
```

For one-shot commands with title and body:

```bash
git commit --signoff \
  -m "area: Summary starting with an uppercase letter" \
  -m "Explain what changed and why it changed."
```

For amending a commit:

```bash
git commit --amend --signoff
```

If the commit message is edited manually with `git commit --signoff`, do not also
manually add a duplicate `Signed-off-by:` trailer. If drafting a message for the
user to paste into an editor, include the `Signed-off-by:` trailer exactly once.

Never suggest a plain `git commit` command when the task is to create, amend, or
finalize a commit. Use `git commit --signoff` instead.

## Title rules

- Prefer the form `area: Summary`.
- Use `area: subarea: Summary` when a nested scope makes the change clearer.
- Area prefixes must use lowercase letters, numbers, `.`, `_`, or `-`, followed by `: `.
- Multiple area prefixes are allowed.
- The summary must start with an uppercase letter after the final prefix.
- Keep the title short and imperative.
- Do not end the title with a period.
- Use the most specific area that helps reviewers locate the change.
- Follow the repository's existing commit history when choosing prefixes.

Good title examples:

```text
software: Add target kernel deployment procedure
fpga: Document CAN controller register fields
product: Add CODEOWNERS for documentation areas
docs: Add Antora component configuration
ci: Run textlint for AsciiDoc files
drivers: timer: Remove unused timer index
```

Bad title examples:

```text
software: add target kernel deployment procedure
```

The summary starts with lowercase `add`, so it violates the title regex.

```text
Fix stuff
```

This may pass the regex, but it is too vague and lacks a useful area prefix.

```text
software:add target kernel deployment procedure
```

There must be a space after `:`.

```text
Software: Add target kernel deployment procedure
```

Area prefixes must be lowercase to match the configured regex.

## Body rules

Always include a non-empty body. Even small changes need a short explanation.

The body should usually answer:

- What changed?
- Why is the change needed?
- What behavior, workflow, hardware, document, or user-facing result does it affect?
- How was it checked, when that is relevant?

Write the body as normal prose. Prefer one or two short paragraphs over a vague
single sentence.

### Body length constraints

Apply these constraints to the commit body before returning or committing a
message:

- Body text is mandatory. Do not use an empty body.
- Body text should contain at least two meaningful sentences when the change is
  more than a trivial metadata update.
- Body text lines must be wrapped at 72 characters or less.
- Trailer lines such as `Signed-off-by:`, `Acked-by:`, and `Tested-by:` are
  exempt from the 72-character body line limit.
- Reference link lines such as `[1]: https://...` are exempt from the
  72-character body line limit.
- Avoid filler bodies such as `Update files.` or `Fix issue.`. Expand them to
  explain the intent and effect of the change.

If a generated commit body has a line longer than 72 characters, rewrap it
before returning the final answer or running `git commit`.

Good body pattern:

```text
Add instructions for setting CONFIG_LOCALVERSION when building the kernel
outside the standard build system.

This makes the kernel release string explicit, which helps distinguish manually
built kernels and keeps the module installation directory aligned with the
running kernel.
```

For documentation-only changes, explain the documentation structure or the reader
problem being solved:

```text
Add the Japanese Antora component configuration so the existing AsciiDoc files
can be handled as an Antora module.

This makes the component discoverable from the playbook and provides a stable
start page and navigation entry for the generated site.
```

For generated files, explain the source of generation when useful:

```text
Update the generated hardware description files after regenerating the platform
from the latest hardware design.

The regenerated files keep the committed hardware artifacts in sync with the
platform description used by the build.
```

For mechanical lint or formatting changes, state the rule or motivation:

```text
Fix repeated particles reported by the Japanese technical writing rule.

This keeps the prose consistent with the repository textlint configuration
without changing the technical meaning of the affected paragraphs.
```

## Trailer rules

Add trailers after a blank line at the end of the body.

`Signed-off-by:` is mandatory for every final commit message.

Allowed trailer examples:

```text
Signed-off-by: Full Name <email@example.com>
Acked-by: Reviewer Name <reviewer@example.com>
Co-Authored-by: Coauthor Name <coauthor@example.com>
Reported-by: Reporter Name <reporter@example.com>
Tested-by: Tester Name <tester@example.com>
```

Do not invent non-sign-off trailer lines. Use names and email addresses only if
the user provided them or they are already known in the current task context.

For `Signed-off-by:`, prefer letting Git generate the line with
`git commit --signoff`. When only drafting text and the Git identity is unknown,
use `Signed-off-by: Full Name <email@example.com>` as a placeholder and tell the
user to replace it or commit with `--signoff`.

## How to choose the area prefix

Use previous commits that touched the same files as the best guide. When that is
not available, choose a prefix from the path, subsystem, or change type.

Common examples:

```text
software: ...
fpga: ...
product: ...
docs: ...
ci: ...
build: ...
scripts: ...
tests: ...
drivers: subsystem: ...
```

For repository-specific documentation, prefer the top-level component name when
it exists, for example `software:`, `fpga:`, or `product:`.

## Review checklist

Before returning a commit message or command, verify these points:

1. The title matches `^(([a-z0-9._-]+: )+)?[A-Z].*`.
2. The title uses `area: Summary` style unless there is a strong reason not to.
3. The area prefix is lowercase and followed by `: `.
4. The summary starts with an uppercase letter.
5. The title does not end with a period.
6. The message has a blank line after the title.
7. The body is non-empty and explains both what and why.
8. Body text lines are wrapped at 72 characters or less, excluding trailers and
   reference links.
9. The body is specific enough to avoid filler such as `Update files.`.
10. Trailer lines are separated from the body by a blank line.
11. `Signed-off-by:` is present in every final commit message.
12. Any suggested `git commit` command uses `--signoff` or `-s`.
13. The message does not contain duplicate `Signed-off-by:` trailers.

## Output style

When the user asks for a commit message, return the final message in a code block.
When the user asks for the command to commit changes, include `git commit
--signoff` or `git commit -s`.

When useful, add a short note explaining why the title/body/sign-off satisfies
the rule. Do not over-explain unless the user asks for review details.
