# Required GitHub Secrets

This project uses GitHub Actions to automatically build and deploy the MkDocs site via FTPS.

## How to Configure

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** for each secret below

## Required Secrets

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `FTP_SERVER` | Your FTP/FTPS server hostname | `ftp.example.com` |
| `FTP_USERNAME` | FTP account username | `deploy@example.com` |
| `FTP_PASSWORD` | FTP account password | (your password) |
| `FTP_SERVER_DIR` | Remote directory to deploy to | `/public_html/` or `/www/brams-journey/` |

## Notes

- **Never commit actual credentials to the repository**
- The workflow uses FTPS (FTP over TLS) for secure transfer
- If your host uses a non-standard port, uncomment the `port` line in `deploy.yml`
- The workflow triggers automatically on push to `main`, or can be run manually via GitHub Actions UI

## Testing the Connection

Before relying on the GitHub Action, you can test your FTP credentials locally:

```bash
# Using lftp (install with: apt install lftp / brew install lftp)
lftp -u username,password -e "ls; quit" ftps://ftp.example.com
```

## Troubleshooting

- **Connection refused**: Check if FTPS is enabled on your host (vs plain FTP or SFTP)
- **Permission denied**: Verify the remote directory exists and the FTP user has write access
- **Certificate errors**: Some hosts require explicit TLS; the action handles this automatically
