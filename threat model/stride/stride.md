# STRIDE Threat Model — Enterprise IT

A generic, reusable STRIDE threat model for enterprise IT environments. Covers common threat categories, example attack scenarios, and mitigations. Designed to be forked and adapted to specific systems or applications.

---

## Framework Overview

| Letter | Threat | Security Property Violated |
|--------|--------|---------------------------|
| S | Spoofing | Authentication |
| T | Tampering | Integrity |
| R | Repudiation | Non-repudiation |
| I | Information Disclosure | Confidentiality |
| D | Denial of Service | Availability |
| E | Elevation of Privilege | Authorization |

---

## S — Spoofing

**Definition:** An attacker impersonates a legitimate user, system, or service to gain unauthorized access.

### Threats

| ID | Threat | Description |
|----|--------|-------------|
| S-01 | Credential theft | Attacker obtains valid credentials via phishing, keylogging, or credential dumping (e.g. LSASS) |
| S-02 | Pass-the-Hash / Pass-the-Ticket | Attacker uses captured NTLM hashes or Kerberos tickets without knowing the plaintext password |
| S-03 | Service account impersonation | Overprivileged service accounts are compromised and used to authenticate to other systems |
| S-04 | Email spoofing | Attacker sends email appearing to originate from a trusted internal or external domain |
| S-05 | Man-in-the-Middle (MitM) | Attacker intercepts authentication traffic to replay or forge identity |
| S-06 | API key/token theft | Bearer tokens or API keys are exfiltrated from code repos, config files, or memory |

### Mitigations

- Enforce MFA on all user and admin accounts, including service accounts where feasible
- Deploy phishing-resistant MFA (FIDO2/passkeys) for privileged accounts
- Implement Credential Guard to protect LSASS from dumping attacks
- Enforce SPF, DKIM, and DMARC on all sending domains; reject/quarantine failures
- Rotate service account credentials regularly; prefer Managed Service Accounts (gMSA)
- Scan code repositories for secrets using pre-commit hooks and pipeline secret scanning
- Use certificate-based mutual authentication (mTLS) for service-to-service communication
- Enable Conditional Access policies to restrict authentication by device compliance, location, and risk signal

---

## T — Tampering

**Definition:** An attacker modifies data, code, or system configuration without authorization.

### Threats

| ID | Threat | Description |
|----|--------|-------------|
| T-01 | Database record modification | Attacker with DB access alters records — financial data, audit logs, user roles |
| T-02 | Log tampering | Attacker clears or modifies event logs to remove evidence of compromise |
| T-03 | Supply chain / dependency tampering | Malicious code introduced via third-party packages or build pipeline compromise |
| T-04 | Configuration drift | Unauthorized changes to system or application configuration weaken security posture |
| T-05 | In-transit data modification | Unencrypted or improperly signed traffic is intercepted and altered |
| T-06 | Firmware/bootloader tampering | Physical or remote attacker modifies firmware to persist below the OS layer |

### Mitigations

- Enforce write-once, append-only storage for audit and security logs; ship logs to a SIEM in real time
- Implement file integrity monitoring (FIM) on critical OS files, configs, and binaries
- Use code signing for all deployed software and enforce signature validation at runtime
- Pin dependencies and verify package integrity via checksums in CI/CD pipelines; use a private artifact registry
- Encrypt all data in transit using TLS 1.2+ with strong cipher suites; enforce HSTS
- Enforce RBAC with least privilege on all data stores; separate read and write roles
- Use Infrastructure-as-Code (IaC) with version control and drift detection (e.g. Terraform, Azure Policy, AWS Config)
- Enable Secure Boot and TPM attestation to detect firmware/bootloader compromise

---

## R — Repudiation

**Definition:** A user or attacker performs an action and later denies doing so, because no reliable record exists.

### Threats

| ID | Threat | Description |
|----|--------|-------------|
| R-01 | Insufficient audit logging | Critical actions (privilege changes, data exports, account creation) are not logged |
| R-02 | Log deletion | Attacker with local admin rights deletes or overwrites event logs |
| R-03 | Shared credentials | Multiple users share a single account, making individual attribution impossible |
| R-04 | Unsigned transactions | Financial or configuration changes lack cryptographic proof of origin |
| R-05 | No log retention policy | Logs exist but are purged before an incident is investigated |

### Mitigations

- Define and enforce a minimum logging standard covering authentication, authorization changes, data access, and admin actions
- Forward all logs to a centralized, tamper-evident SIEM with immutable storage (e.g. Azure Monitor, Splunk, Sumo Logic)
- Prohibit shared accounts; enforce one identity per human and per service
- Implement digital signatures or HMAC for high-value transactions (financial records, config changes)
- Set log retention policy aligned to regulatory requirements (e.g. 90 days hot, 1 year cold); enforce via policy
- Enable User and Entity Behavior Analytics (UEBA) to detect anomalous activity patterns
- Require privileged access workstations (PAWs) for admin tasks to reduce log noise and improve attribution

---

## I — Information Disclosure

**Definition:** Sensitive data is exposed to parties who should not have access to it.

### Threats

| ID | Threat | Description |
|----|--------|-------------|
| I-01 | Data exfiltration | Attacker copies sensitive data to an external destination via network, USB, or cloud sync |
| I-02 | Overpermissioned access | Users or services have read access to data beyond their role requirements |
| I-03 | Unencrypted data at rest | Sensitive data stored in plaintext on disk, backups, or removable media |
| I-04 | Verbose error messages | Application stack traces or internal paths exposed in error responses |
| I-05 | Misconfigured cloud storage | S3 buckets, Azure Blob containers, or SharePoint sites left publicly accessible |
| I-06 | Secrets in source code | Passwords, API keys, or certificates committed to version control |
| I-07 | Insider threat | Legitimate user with access intentionally or accidentally leaks sensitive data |

### Mitigations

- Classify data (Public / Internal / Confidential / Restricted) and enforce access controls per classification
- Implement least-privilege access; conduct periodic access reviews (quarterly recommended)
- Encrypt sensitive data at rest using AES-256; manage keys via a dedicated KMS (HSM-backed where required)
- Configure generic error pages in production; log detailed errors server-side only
- Audit cloud storage ACLs continuously; block public access at the account/subscription level by policy
- Scan all repos for secrets using tools like `truffleHog`, `gitleaks`, or GitHub Advanced Security
- Deploy DLP controls at email, endpoint, and cloud egress points
- Enable Cloud Security Posture Management (CSPM) to detect misconfigured resources

---

## D — Denial of Service

**Definition:** An attacker degrades or disrupts the availability of a system or service.

### Threats

| ID | Threat | Description |
|----|--------|-------------|
| D-01 | Volumetric DDoS | Attacker floods network or application layer with traffic to exhaust bandwidth or compute |
| D-02 | Resource exhaustion | Malformed requests or logic bombs consume CPU, memory, or disk until service degrades |
| D-03 | Account lockout abuse | Attacker deliberately triggers lockout policy against target accounts to disrupt access |
| D-04 | Ransomware | Attacker encrypts critical data or systems, making them unavailable until ransom is paid |
| D-05 | Dependency failure | Reliance on a single external service or CDN creates a single point of failure |
| D-06 | Storage exhaustion | Attacker floods logging, upload, or storage endpoints to fill disk and cause failures |

### Mitigations

- Deploy DDoS protection at the network edge (e.g. Azure DDoS Protection, AWS Shield, Cloudflare)
- Implement rate limiting and request throttling on all public-facing APIs and authentication endpoints
- Configure account lockout thresholds carefully; use risk-based lockout rather than hard counters where possible
- Maintain tested, offline backups following a 3-2-1 strategy; test restoration regularly
- Design for redundancy: load balancing, multi-region failover, and health checks on all critical services
- Define and test a Business Continuity Plan (BCP) and Disaster Recovery Plan (DRP) with documented RTOs and RPOs
- Implement storage quotas on upload and logging endpoints to prevent exhaustion attacks
- Segment networks to limit blast radius of any single compromise or failure

---

## E — Elevation of Privilege

**Definition:** An attacker gains capabilities or access beyond what they are authorized for.

### Threats

| ID | Threat | Description |
|----|--------|-------------|
| E-01 | Vertical privilege escalation | Low-privileged user gains admin or root access via unpatched vulnerability or misconfiguration |
| E-02 | Horizontal privilege escalation | User accesses another user's data or functions at the same privilege level |
| E-03 | Kerberoasting | Attacker requests service tickets for SPNs and cracks them offline to obtain service account credentials |
| E-04 | Token manipulation | Attacker steals or forges access tokens (JWT, OAuth, SAML) to impersonate higher-privileged identities |
| E-05 | Sudo/UAC abuse | Overly permissive sudo rules or UAC bypass techniques allow unprivileged code to run as root/SYSTEM |
| E-06 | Path traversal / IDOR | Application logic flaws allow a user to access objects or paths they are not authorized for |
| E-07 | Misconfigured IAM roles | Cloud IAM roles with wildcard permissions or trust policies that allow lateral movement |

### Mitigations

- Enforce least-privilege across all systems; regularly review and trim excessive permissions
- Implement Just-In-Time (JIT) privileged access — grant elevated access on demand with time limits and approval workflows
- Enforce Privileged Identity Management (PIM) for all admin roles in cloud and identity platforms
- Harden Kerberos: use long, random passwords for service accounts; consider Managed Service Accounts (gMSA); enable AES encryption for Kerberos
- Validate and sign all tokens; enforce short expiry windows and token binding where supported
- Audit sudo rules and UAC configuration; alert on any changes
- Enforce object-level authorization checks in application code; never rely on client-supplied object IDs without server-side validation
- Scan IaC templates and cloud configurations for wildcard IAM permissions before deployment
- Conduct regular purple team exercises targeting privilege escalation paths

---

## How to Use This Model

1. **Scope** — Define the system boundary: what's in scope (applications, infrastructure, identities, data flows)?
2. **Map assets** — List assets that, if compromised, would cause harm (data stores, admin interfaces, secrets, integrations).
3. **Apply STRIDE** — For each asset or data flow, walk through each threat category and identify applicable threats from the tables above.
4. **Rate risk** — Score each identified threat by likelihood and impact (e.g. DREAD or CVSS) to prioritize remediation.
5. **Assign mitigations** — Map threats to mitigations; assign owners and target dates.
6. **Review cadence** — Re-run the model when significant architectural changes occur, or at minimum annually.

---

*Fork this model and replace the generic examples with threats specific to your environment. Add or remove rows from any table to match your technology stack and risk appetite.*
