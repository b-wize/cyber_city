# Security Software Review Framework

Capability-driven approval guidance for repeatable software reviews.

---

## Purpose

The Security Software Review Framework standardizes software reviews by evaluating the capability a product enables, the controls that govern that capability, and the requester role. Routine requests should follow established policy; Security Architecture review is reserved for genuine exceptions.

---

## Guiding Principles

- Review capabilities, not software names.
- Technical controls provide the security posture; approvals provide governance.
- Managers validate business need; Security Architecture defines capabilities, controls, and eligible roles.
- Auto-approve routine requests when the capability, controls, and role align.
- Use manual review for new capabilities, control gaps, elevated functionality, or other architectural exceptions.

---

## Required Inputs

| Input | Notes |
|---|---|
| Requester | Who is making the request |
| Requested Software | The application or tool being reviewed |
| Business Reason | The stated use case and business justification |
| Architectural Assessment | Optional — populated for exceptions or complex reviews |

---

## Architectural Assessment

**If blank:** execute the framework as defined. Do not add subjective architectural judgment to a routine request.

**If populated:** use the supplied context for nuance, precedent, implementation details, pilot status, known control conditions, or other information needed to make an informed architectural decision.

---

## Review Workflow

### 1. Identify Requestor

Verify user via your ITSM platform record:

- Confirm requestor identity.
- Confirm title, business unit, sector/function, region.
- Determine the requestor role from the available record information.
- Validate role alignment with the requested application/capability and stated business reason.

---

### 2. Identify and Assess the Capability

Determine what the requested software enables. Do not classify solely from the product name or vendor category.

| Resource | Use |
|---|---|
| Capability Matrix | Primary source for previously classified capabilities, expected controls, roles, and established decisions. |
| ITSM Software Catalog / CMDB | Check whether the application or an equivalent product has already been classified and its current disposition. |
| Business Reason | Establish the functionality the requester actually intends to use. |
| Vendor Documentation | Use when functionality is unclear or additional capabilities may exist beyond the stated use case. |
| Security Architecture | Use when the capability is new, ambiguous, or introduces an architectural exception. |

Specifically identify functionality that may independently affect the security posture, including Cloud & Sync, AI features, alternate execution environments, browser automation, privileged administration, credential handling, or new trust boundaries.

> **Capability already defined?** Yes → continue to control validation. No → route to Security Architecture to define the capability and control model.

---

### 3. Validate Existing Controls

Use the expected control coverage below to identify which enterprise controls would generally be expected for the capability. Then use the application's ITSM software/CMDB record to determine which controls are actually applied to that application.

#### Expected Control Coverage by Capability

| Capability Bucket | Expected Controls |
|---|---|
| Productivity & Analytics | Standard User Permissions; AppLocker; Intune; Defender; Sentinel |
| Development & Automation | Standard User Permissions; AppLocker; Intune; Defender; Sentinel; AD Security Groups (where scoped) |
| Enterprise Integration & Administration | AppLocker; Intune; Defender; Sentinel; AD Security Groups |
| Collaboration & AI | Intune; Defender; Sentinel; AIM Browser Governance; MAM (where mobile) |
| Elevated Capability | Capability-specific controls; Security Architecture review required |

> Expected controls identify the enterprise controls that would generally be expected to govern a capability. They do not confirm that a control is configured for a specific application. Application-specific control implementation should be recorded and validated in the authoritative ITSM software/CMDB record.

#### Control Validation Gates

**Required Controls Identified?** Do we know what should protect this capability? If no, define the required control posture before approval.

**Are Controls Working?** Does ITSM or supporting evidence confirm that the applicable controls are configured for this application and operating as intended? If no or unknown, validate, implement, and test the controls before proceeding through the standard approval path.

Evidence may include AppLocker policy, Intune configuration, AD/Entra security groups, firewall/proxy restrictions, Defender policy, AIM/browser policy, MAM policy, platform RBAC, or validation from the responsible control owner.

> Control validation occurs at the capability/application level, not for every individual request. Once controls are identified, implemented, tested, and documented, repeat requests inherit that established posture unless the capability, architecture, or control implementation materially changes.

#### ITSM Software / CMDB Record

Maintain application-specific implementation in your ITSM platform rather than expanding this playbook into an application-to-control inventory.

| Suggested Attribute | Purpose |
|---|---|
| Capability | Maps the application to the framework capability. |
| Applied Security Controls | Lists the controls actually applied to the application; preferably a controlled multi-select. |
| Control Status | Verified / Unverified / Not Applicable. |
| Control Notes | Optional implementation context or control-owner reference. |
| Software Disposition | General Approved / Restricted / General Deny. |
| Role Scope (optional) | Supports auto-approval by identifying roles that ordinarily require the capability. |

---

### 4. Determine the Decision

| Framework Outcome | ITSM Disposition | Use |
|---|---|---|
| Approve | General Approved | Known capability; applicable controls are verified; requester/role alignment is appropriate. Repeat requests should normally proceed without InfoSec review. |
| Conditional / Manual Review | Restricted | Context matters: role/scope, dependency, control gap, data handling, elevated functionality, or another condition requires human review. |
| Deny | General Deny | Capability conflicts with established security posture or cannot currently be sufficiently controlled. |

---

## Manual Review Triggers

- New or unclassified capability
- New trust boundary
- Cloud & Sync capability requiring additional data-handling review
- AI functionality requiring additional governance review
- Browser automation
- Alternate execution environments
- Privileged administration or credential management
- Required controls are missing, unverified, or not operating as expected
- Requester role is not eligible or business alignment is unclear

---

## Decision Philosophy

Security Architecture approves the capability and control model, rather than repeatedly approving individual users of an already-understood capability. Individual requests should consume that established decision.

The requester and manager remain accountable for the stated business need. ITSM preserves the requester, business justification, approval history, capability mapping, controls, and disposition as the audit trail. Technical controls provide prevention and detection after the capability is enabled.

---

## Repeatable Decision Path

```
Requester / Role Verification → Capability Mapping → Cloud/Sync & AI Checks → Capability Defined → Required Controls Identified → Controls Working → Auto-Approve → Platform Enforcement → Provision Capability
```

---

## Framework Goals

Decisions should be consistent, repeatable, objective, defensible, and automatable. Routine requests should require minimal human intervention, while Security Architecture time is reserved for genuine architectural decisions, new capabilities, and exceptions.
