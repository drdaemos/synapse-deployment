# Synapse Matrix Homeserver - Railway Deployment

Deploy a Matrix Synapse homeserver on Railway.com with PostgreSQL.

## Quick Deploy to Railway

1. **Create a new Railway project** from this repo

2. **Add PostgreSQL database:**
   - In Railway dashboard, click "New" → "Database" → "PostgreSQL"
   - Railway will automatically create and link the database with environment variables

3. **Set environment variables:**
   - `SERVER_NAME` = `matrix.yourdomain.com` (your Matrix server domain)

4. **Deploy and get the signing key:**
   - Deploy once to let Synapse generate a signing key
   - In Railway, open the service logs or use CLI:
     ```bash
     railway logs | grep "signing key"
     ```
   - Or connect to your service and run:
     ```bash
     cat /data/homeserver.signing.key
     ```
   - Copy the entire output (format: `ed25519 a_RXGa "base64_key_here"`)

5. **Save the signing key (CRITICAL):**
   - In Railway dashboard, add environment variable:
   - `SYNAPSE_SIGNING_KEY` = `ed25519 a_RXGa "your_key_here"`
   - This persists your key across deploys
   - **Without this, your key regenerates on each deploy → federation breaks, users can't log in**

6. **Optional: Add volume for media storage:**
   - If you want to persist uploaded media across deploys:
   - Go to "Volumes" → "New Volume"
   - Set mount path: `/data`
   - Without a volume, media storage is ephemeral (lost on redeploy)

7. **Set up a custom domain** (recommended):
   - In Settings → Networking, add your domain
   - Point your DNS to Railway's provided URL
   - Make sure `SERVER_NAME` matches your domain

## How It Works

The deployment uses a startup script that:
1. Reads `homeserver.yaml.template`
2. Replaces `${VAR}` placeholders with environment variables
3. Generates the final `homeserver.yaml`
4. Starts Synapse

This keeps secrets out of your repository while staying Railway-friendly.

## Important Notes

- **CRITICAL - Signing Key:** Save `SYNAPSE_SIGNING_KEY` env var after first deploy, or your key will regenerate and break everything
- **Environment Variables:** Railway auto-provides `PGUSER`, `PGPASSWORD`, `PGDATABASE`, `PGHOST`, `PGPORT` when you add PostgreSQL
- **Media Storage:** Without a volume, media is ephemeral (lost on redeploy)
- **Registration:** Currently open (anyone can register)
- **Federation:** Enabled - your server can communicate with other Matrix servers

## Accessing Your Server

Once deployed, your homeserver will be available at:
- Client API: `https://your-railway-domain.railway.app`
- Default port: 8008 (Railway handles HTTPS automatically)

## Connecting with a Client

Use any Matrix client (Element, FluffyChat, etc.) and point it to your homeserver URL.

## Monitoring

Metrics are exposed on port 9090 for Prometheus monitoring (optional).

## Local Development

1. Copy `.env.example` to `.env` and fill in your database credentials
2. Run: `docker build -t synapse .`
3. Run: `docker run -p 8008:8008 --env-file .env synapse`

## Configuration

- `homeserver.yaml` - Main Synapse configuration
- `logging.yaml` - Logging configuration (outputs to stdout for Railway)
