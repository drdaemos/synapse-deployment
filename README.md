# Synapse Matrix Homeserver - Railway Deployment

Deploy a Matrix Synapse homeserver on Railway.com with PostgreSQL.

## Quick Deploy to Railway

1. **Create a new Railway project** from this repo

2. **Add PostgreSQL database:**
   - In Railway dashboard, click "New" → "Database" → "PostgreSQL"
   - Railway will automatically create and link the database

3. **Configure environment variables:**
   Railway will auto-populate database variables, but verify these are set:
   - `DB_USER`
   - `DB_PASSWORD`
   - `DB_NAME`
   - `DB_HOST`
   - `DB_PORT`

4. **Add a volume for persistent storage:**
   - In your service settings, go to "Volumes"
   - Click "New Volume"
   - Set mount path: `/data`
   - This ensures your signing keys and media don't get lost on redeploys

5. **Set up a custom domain** (optional but recommended):
   - In Settings → Networking, add your domain
   - Point your DNS to Railway's provided URL
   - Your server name is: `drdaemos.cc` (configured in homeserver.yaml)

## Important Notes

- **Signing Key:** Generated automatically on first run and stored in `/data` volume
- **Media Storage:** Stored locally in `/data/media_store` volume
- **Registration:** Currently open (anyone can register) - fine for personal use
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
