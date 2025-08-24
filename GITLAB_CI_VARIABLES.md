# GitLab CI Variables Configuration

This document lists all the required GitLab CI variables that need to be configured in your GitLab project settings for the gitleaks pipeline to work properly.

## Required Variables

### Registry Authentication
These variables are used for Docker registry authentication:

| Variable | Description | Example |
|----------|-------------|---------|
| `CI_REGISTRY_USER` | Username for your local Docker registry | `registry-user` |
| `CI_REGISTRY_PASSWORD` | Password for your local Docker registry | `your-registry-password` |

### Nextcloud Notification
These variables are used for sending notifications via Nextcloud Talk:

| Variable | Description | Example |
|----------|-------------|---------|
| `NEXCLOUD_USERNAME` | Nextcloud username for API authentication | `your-nexcloud-user` |
| `NEXCLOUD_PASSWORD` | Nextcloud password for API authentication | `your-nexcloud-password` |
| `NEXCLOUD_URL` | Base URL of your Nextcloud instance | `https://your-nexcloud.com` |
| `NEXCLOUD_CONVERSATION_TOKEN` | Token for the specific Nextcloud Talk conversation | `abc123def456` |

## How to Configure Variables

1. Go to your GitLab project
2. Navigate to **Settings** → **CI/CD**
3. Expand the **Variables** section
4. Click **Add Variable** for each required variable
5. Set the variable type to **Variable** (not File)
6. For sensitive data like passwords, check **Protect variable** and **Mask variable**

## Variable Types

- **Variable**: Regular text value
- **File**: Content that will be written to a file
- **Protected**: Only available in protected branches/tags
- **Masked**: Hidden in job logs (recommended for passwords)

## Security Best Practices

1. **Use Protected Variables**: For sensitive data, enable the "Protected" option
2. **Mask Sensitive Data**: Enable "Mask variable" for passwords and tokens
3. **Environment-Specific**: Consider using different values for different environments
4. **Regular Rotation**: Regularly update passwords and tokens
5. **Least Privilege**: Use accounts with minimal required permissions

## Testing Variables

You can test if variables are properly configured by adding a debug job to your pipeline:

```yaml
debug-variables:
  stage: docker
  script:
    - echo "Testing variable configuration..."
    - echo "Registry: $CI_REGISTRY"
    - echo "Username: $CI_REGISTRY_USER"
    - echo "Nexcloud URL: $NEXCLOUD_URL"
  only:
    - main
  when: manual
```

## Troubleshooting

### Common Issues

1. **Authentication Failed**: Check `CI_REGISTRY_USER` and `CI_REGISTRY_PASSWORD`
2. **Notification Not Sent**: Verify Nextcloud variables and conversation token
3. **Permission Denied**: Ensure the registry user has push permissions
4. **Variable Not Found**: Check if variables are set for the correct branch/environment

### Debug Commands

Add these to your pipeline for debugging:

```bash
# Test registry login
docker login -u $CI_REGISTRY_USER --password-stdin $CI_REGISTRY

# Test Nextcloud API
curl -X POST \
  -u "$NEXCLOUD_USERNAME:$NEXCLOUD_PASSWORD" \
  -H "OCS-APIRequest: true" \
  "$NEXCLOUD_URL/ocs/v2.php/apps/spreed/api/v1/chat/$NEXCLOUD_CONVERSATION_TOKEN"
```
