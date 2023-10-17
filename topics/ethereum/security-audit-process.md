# Security Audit Process

- Specification Analysis:
    What is the app supposed to do?
    What are assumptions?
    Who are the actors & what are their privileges?

- Documentation Analysis
    Better docs = better audit

- Automated Testing

- Automated Static Analysis
    Slither
    Mythril

- Automated Fuzzing
    Echidna
    Harvey

- Automated Symbolic Checking
    Check all code paths, best for projects of 500-1000 loc

- Automated Formal Verifiction

- Manual Analysis <--
    Human auditor
    Spec = "why" its been designed how it is
    Docs = "how" its been designed how it is
    Identify gaps between Spec and Docs!
    Test business logic
      - Access
      - Asset flow thru system
      - Control flow
      - Data flow
      - Constraints (are constraints faulty?)
      - Dependencies
      - Assumptions
      - Checklists

- Write Report & Present Findings
    Including impact, severity, risk, exploit scenarios (can include code), remediation.
    Debate findings.

- Public Release (if agreed upon)

- Review
    Validate fixes to confirm mitigation.
