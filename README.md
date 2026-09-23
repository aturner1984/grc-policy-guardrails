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
