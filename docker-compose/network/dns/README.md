# AdGuard Home + Unbound DNS Stack

AdGuard Home (ad-blocking DNS resolver) with Unbound as its upstream resolver. Unbound forwards to Cloudflare and Quad9 over DNS-over-TLS (DoT) and DNS-over-HTTPS (DoH), with DNSSEC validation.

## Files

| File | Purpose |
| --- | --- |
| `docker-compose.yml` | Stack definition |
| `.env.example` | Environment variables template |
| `config/unbound/unbound.conf` | Unbound configuration (forwarders, DNSSEC) |
| `config/unbound/root.hints` | Root name server hints |

## Ports

| Port | Service | Description |
| --- | --- | --- |
| `53/tcp`, `53/udp` | AdGuard Home | DNS server (clients query this) |
| `3000/tcp` | AdGuard Home | Web UI (first-run setup wizard) |
| `5353/tcp`, `5353/udp` | Unbound | Upstream resolver, bound to `127.0.0.1` only |

## Quick start

```bash
cd dns
cp .env.example .env   # edit TZ if needed
docker compose up -d
```

After the containers start, open http://<host>:3000 and run the first-run wizard. Then configure AdGuard Home to use Unbound as its upstream resolver:

1. AdGuard Home web UI → **DNS Settings** → **Upstream DNS servers**
2. Add: `http://127.0.0.1:5353/dns-query` (or simply `127.0.0.1:5353`)

## Upstream forwarders

Unbound forwards all queries to (in order):

1. Cloudflare DoT — `1.1.1.1`, `1.0.0.1`
2. Quad9 DoT — `9.9.9.9`, `149.112.112.9`
3. Cloudflare DoH — `https://cloudflare-dns.com/dns-query`
4. Quad9 DoH — `https://dns.quad9.net/dns-query`
5. Plain TCP/UDP fallback — `1.1.1.1`, `9.9.9.9`

## Persistence

- AdGuard Home config: `./config/adguard/conf` → `/opt/adguardhome/conf`
- AdGuard Home work dir: `./config/adguard/work` → `/opt/adguardhome/work`
- Unbound config: `./config/unbound` → `/etc/unbound`