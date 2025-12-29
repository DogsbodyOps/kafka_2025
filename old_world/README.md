# Legacy Kafka Setup Scripts

⚠️ **WARNING: These are legacy scripts kept for historical reference only.**

## Status

These scripts are from an older deployment approach and are **not actively maintained**. They are kept in the repository for reference purposes and to preserve deployment history.

## Current Deployment

Please use the current deployment approach documented in the main repository README:
- `deployment_script.sh` (Zookeeper mode)
- `deployment_script_kraft.sh` (KRaft mode)
- `docker-compose.yml`

## Known Issues in Legacy Scripts

### rest.sh
- Lines 25-26 contain empty password placeholders:
  ```bash
  -e KAFKA_REST_CLIENT_SSL_KEYSTORE_PASSWORD="" \
  -e KAFKA_REST_CLIENT_SSL_TRUSTSTORE_PASSWORD="" \
  ```
- **These passwords should be provided as environment variables before running the script**
- In the current deployment approach, these are properly managed via `.env` files

### General Notes
- These scripts use hardcoded hostnames specific to the old environment
- SSL/TLS configuration may differ from current standards
- Version numbers may be outdated

## Migration

If you need to migrate from these legacy scripts to the current deployment:
1. Review your current configuration
2. Use the new `deployment_script.sh` or `deployment_script_kraft.sh`
3. Ensure all secrets are properly configured via environment variables
4. Test in a non-production environment first

## Questions?

For questions about current deployment practices, refer to the main README.md or contact the infrastructure team.
