# Policy-as-Code CI/CD Guardrails Engine

![Compliance Guardrails](https://img.shields.io/badge/GRC%20Engineering-Policy%20as%20Code-blue)
![Framework](https://img.shields.io/badge/Control%20Framework-SOC%202%20%7C%20ISO%2027001%20%7C%20NIST%20800--53-brightgreen)
![Tooling](https://img.shields.io/badge/Tooling-Terraform%20%7C%20Checkov%20%7C%20GitHub%20Actions-orange)

## Executive Summary
This project demonstrates **Pre-Deployment Compliance Enforcement** (Shift-Left GRC Engineering) by embedding custom security and governance policies directly into CI/CD deployment pipelines.

Instead of relying on manual quarterly audit checks, infrastructure code (Terraform) is automatically evaluated against custom organizational policies written in Checkov YAML engines on every Pull Request. Non-compliant deployments are blocked dynamically prior to cloud provisioning.

---

## 🛡️ Control Mapping Matrix

| Policy ID | Category | Enforcement Scope | Target Control Framework |
| :--- | :--- | :--- | :--- |
| **CUSTOM_GRC_AWS_001** | Convention | Enforces mandatory `CostCenter` metadata tag on all S3 resources. | **SOC 2 Type II** (CC6.1) / **ISO 27001** (A.8.1.1 Asset Inventory) |
| **CUSTOM_GRC_AWS_002** | Networking | Disallows inbound SSH (Port 22) from `0.0.0.0/0` in Security Groups. | **NIST SP 800-53** (AC-17 / SC-7) / **PCI-DSS 4.0** (Requirement 1.3) |
| **CKV_AWS_19** | Encryption | Mandates default Server-Side Encryption (AES256/KMS) for data at rest. | **SOC 2 Type II** (CC6.6) / **ISO 27001** (A.10.1 Cryptographic Controls) |

---

## 🛠️ Tech Stack & Dependencies
* **Infrastructure as Code:** Terraform (`aws_s3_bucket`, `aws_security_group`)
* **Static Analysis Engine:** Checkov (Prisma Cloud open-source static analyzer)
* **Continuous Integration:** GitHub Actions (`.github/workflows/policy_gate.yml`)
* **Policy Language:** Custom Checkov YAML Definitions

---

## 🚀 Local Reproduction Guide

1. Clone the repository:
   ```bash
   git clone [https://github.com/aturner1984/grc-policy-guardrails.git](https://github.com/aturner1984/grc-policy-guardrails.git)
   cd grc-policy-guardrails
   ```

2. Install Checkov:
   ```bash
   pip3 install checkov
   ```

3. Execute local policy scan:
   ```bash
   checkov -d . --external-checks-dir ./custom_policies --check CUSTOM_GRC_AWS_001,CUSTOM_GRC_AWS_002
   ```

---

## 🔗 Control → Policy → Technical Enforcement Mapping

This engine translates abstract regulatory compliance requirements into explicit policy logic and automated technical enforcement gates.

```text
[ Compliance Control ]  ────────►  [ Policy Definition ]  ────────►  [ Technical Enforcement ]
  SOC 2 CC6.1 / ISO 27001            CUSTOM_GRC_AWS_001                Checkov CI Pipeline
  "Track Asset Governance"           Mandatory CostCenter Tag          Fails PR on Missing Metadata
```

### Detailed Breakdown

1. **Regulatory Control:** **SOC 2 Type II (CC6.1) / ISO 27001 (A.8.1.1 Asset Inventory)**
   * **Requirement:** The organization must maintain an accurate inventory of cloud infrastructure and attribute resource ownership/cost allocation for access control and governance.
   * **Policy Definition (`custom_policies/enforce_cost_center_tag.yaml`):** Every `aws_s3_bucket` and `aws_security_group` must include a valid `CostCenter` key within its metadata tags.
   * **Technical Enforcement (`.github/workflows/policy_gate.yml`):** GitHub Actions executes `checkov` against incoming Terraform pull requests. If a developer attempts to provision a resource missing the `CostCenter` tag, the pipeline exits with code `1`, leaving inline logs and blocking the PR merge.

2. **Regulatory Control:** **NIST SP 800-53 (AC-17 / SC-7) / PCI-DSS 4.0 (Requirement 1.3)**
   * **Requirement:** Inbound administrative access (such as SSH) must be restricted to internal corporate networks and must never be exposed publicly to the open internet.
   * **Policy Definition (`custom_policies/disallow_open_ssh.yaml`):** Evaluates `aws_security_group` ingress definitions and triggers a `CRITICAL` severity violation if `from_port: 22` is paired with `cidr_blocks: ["0.0.0.0/0"]`.
   * **Technical Enforcement (`.github/workflows/policy_gate.yml`):** Pre-deployment guardrail identifies open management ports before `terraform apply` can execute, preventing dangerous network exposure prior to cloud provisioning.
