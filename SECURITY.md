# Security Policy

## Handling Sensitive Information

This repository contains infrastructure-as-code for Kafka cluster deployment. To maintain security, follow these guidelines:

### ✅ DO

1. **Use Environment Variables**
   - All passwords, secrets, and sensitive configuration should be passed via environment variables
   - Use Azure Pipeline secrets or Azure Key Vault for CI/CD
   - Generate `.env` files at deployment time, never commit them

2. **Proper File Management**
   - Keep certificates and keystores in secure locations (e.g., `/etc/kafka/secrets/`)
   - Mount secrets as Docker volumes, never embed them in images
   - Ensure proper file permissions (600 for private keys, 644 for certificates)

3. **Git Hygiene**
   - Review the `.gitignore` file to ensure sensitive patterns are excluded
   - Use `git status` before committing to verify no sensitive files are staged
   - Consider using pre-commit hooks to scan for secrets

### ❌ DON'T

1. **Never Commit**
   - `.env` files
   - Passwords or API keys (even in comments)
   - Private keys or certificates (`.pem`, `.key`, `.crt`)
   - Keystore or truststore files (`.jks`, `.p12`, `.pfx`)
   - Database connection strings with credentials

2. **Avoid**
   - Hardcoding secrets in scripts or configuration files
   - Sharing secrets via email or unencrypted channels
   - Using weak or default passwords
   - Committing files with "example" or "sample" credentials

## Protected Files (via .gitignore)

The following patterns are automatically excluded from git:

```
.env
*.env
**/secrets/
*.jks
*.p12
*.pem
*.crt
*.key
```

## Secrets Management

### For Local Development

1. Create a `.env` file (it won't be committed)
2. Set all required environment variables:
   ```bash
   KAFKA_REST_CLIENT_SSL_KEYSTORE_PASSWORD=your_password_here
   KAFKA_REST_CLIENT_SSL_TRUSTSTORE_PASSWORD=your_password_here
   ```
3. Source the file before running scripts: `source .env`

### For Azure Pipeline Deployments

1. Store secrets in Azure Pipeline Library or Key Vault
2. Reference them in `azure-pipelines.yml` using `$(SECRET_NAME)` syntax
3. Export them before running deployment scripts:
   ```yaml
   - script: |
       export KAFKA_REST_CLIENT_SSL_KEYSTORE_PASSWORD=$(KEYSTORE_PASSWORD)
       ./deployment_script.sh
   ```

### For Production Deployments

1. Use Azure Key Vault or similar secret management system
2. Implement least-privilege access controls
3. Rotate secrets regularly
4. Audit access to secrets

## Key Rotation

When rotating SSL certificates or passwords:

1. Generate new certificates/passwords
2. Update them in Azure Key Vault or secret management system
3. Deploy to staging environment first
4. Verify functionality
5. Deploy to production with zero-downtime strategy
6. Remove old certificates after successful transition

## Reporting Security Issues

If you discover a security vulnerability:

1. **DO NOT** create a public GitHub issue
2. Contact the security team directly: [your-security-team@causeway.com]
3. Provide details:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested remediation (if any)

We will respond within 48 hours and work with you to address the issue.

## Security Checklist

Before deploying:

- [ ] All secrets are stored in Azure Key Vault or Pipeline secrets
- [ ] No `.env` files are committed to git
- [ ] Certificates and keystores are properly secured
- [ ] File permissions are correct (600 for private keys)
- [ ] SSL/TLS is enabled for all external connections
- [ ] Access controls (ACLs) are properly configured
- [ ] Logs don't contain sensitive information
- [ ] Security patches are up to date

## Compliance

This infrastructure should comply with:

- Company security policies
- Industry standards (e.g., PCI DSS if applicable)
- Data protection regulations (e.g., GDPR if applicable)

## Audit Trail

Security audits are performed regularly. The latest audit report can be found in `SECURITY_AUDIT_REPORT.md`.

## Questions?

For security-related questions, contact:
- Security Team: [your-security-team@causeway.com]
- Infrastructure Team: [your-infra-team@causeway.com]

---

**Last Updated:** December 29, 2025
