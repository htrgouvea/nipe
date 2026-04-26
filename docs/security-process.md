# Security Process

This project adopts a continuous security process that combines prevention, detection, and quality assurance throughout development and delivery.

## 1. Software Composition Analysis (SCA)

Our first layer of protection is dependency security. We use **Dependabot** and **Bunkai** to continuously monitor third-party components and automation artifacts.

- **Dependabot** is configured to review Docker and GitHub Actions dependencies on a weekly schedule, helping keep the project aligned with patched and supported versions.
- **Bunkai** runs as an orchestrated security scan in CI and publishes SARIF results to GitHub Security, improving visibility of composition-related findings and enabling faster triage.

Together, these controls reduce the risk of known vulnerable dependencies remaining in the codebase for long periods.

## 2. Static Application Security Testing (SAST)

For source-code-level analysis, we use **ZARN** as our SAST layer.

- The ZARN workflow performs static security analysis during CI.
- Results are sent to GitHub Security for centralized visibility and tracking.

This allows us to identify insecure coding patterns early, before deployment, and supports a shift-left security posture.

## 3. Security Gate Enforcement

In addition to scanning, we enforce security quality through a dedicated **Security Gate** in CI.

- The Security Gate workflow validates security conditions before changes are accepted.
- It includes checks for Dependabot-related alerts, adding a blocking control to reduce the chance of shipping unresolved dependency risks.

This gate works as an enforcement layer between detection and delivery, strengthening the overall release process.

## 4. Readability and Code Hygiene

Security is reinforced by code clarity. The project maintains **zero linter warnings**, which helps ensure code is easier to review, reason about, and validate.

Clean, consistent code supports faster security reviews and lowers the chance of hidden defects caused by ambiguous or inconsistent implementation.

## 5. Continuous Improvement Through Testing

We are actively expanding unit test coverage to strengthen behavioral guarantees and reduce regression risk.

More comprehensive unit tests improve confidence in refactoring, help detect unintended side effects earlier, and provide stronger support for secure-by-default changes.

## Conclusion

The project security process is built on layered automation and disciplined engineering practices:

- SCA with Dependabot and Bunkai
- SAST with ZARN
- Security Gate enforcement in CI
- Zero linter warnings for maintainability and readability
- Ongoing expansion of unit tests

This approach creates a practical and evolving security baseline, where prevention, detection, and quality controls operate continuously as part of the development lifecycle.
