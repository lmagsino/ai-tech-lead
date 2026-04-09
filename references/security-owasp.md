# Security Reference — OWASP Top 10 (2021)

---

## A01 — Broken Access Control

**What it is:** Users can act outside their intended permissions — accessing other users' data, escalating privileges, or bypassing authorization.

**Code patterns to look for:**
- Authorization only at the UI layer, not enforced server-side
- `user_id` taken from request body instead of session: `DELETE /orders/{id}` with no ownership check
- IDOR (Insecure Direct Object Reference): `GET /invoices/12345` without verifying caller owns invoice 12345
- Missing role checks on admin endpoints
- Path traversal: `../../../etc/passwd` in file path parameters

**Fix:** Enforce authorization server-side on every request. Verify ownership for every resource operation. Deny by default; grant explicitly. Log all access failures.

---

## A02 — Cryptographic Failures

**What it is:** Sensitive data exposed due to weak or missing encryption.

**Code patterns to look for:**
- Passwords stored as plaintext or MD5/SHA1 hashes
- HTTP used instead of HTTPS for sensitive data
- Weak cipher suites (DES, RC4, ECB mode)
- Hardcoded encryption keys or IVs
- Sensitive data logged: `logger.info(f"Processing card: {card_number}")`
- Secrets in environment variables logged at startup

**Fix:** Use bcrypt/scrypt/Argon2 for passwords. Enforce HTTPS. Use AES-256-GCM or ChaCha20. Store secrets in a secrets manager (Vault, AWS Secrets Manager), never in code or logs.

---

## A03 — Injection

**What it is:** Untrusted input interpreted as code or commands by an interpreter (SQL, shell, LDAP, etc.).

**Code patterns to look for:**
```python
# SQL injection
query = f"SELECT * FROM users WHERE email = '{email}'"

# Shell injection
os.system(f"convert {filename} output.jpg")

# LDAP injection, XPath injection — any string concatenation into a query
```

**Fix:** Use parameterized queries for all database access. Never concatenate user input into queries. Use `subprocess` with argument arrays, not shell strings. Validate and sanitize all external input.

---

## A04 — Insecure Design

**What it is:** Missing or ineffective security controls at the design level — not bugs in implementation, but flaws in the security model.

**Code patterns to look for:**
- No rate limiting on authentication endpoints (brute-force risk)
- Password reset tokens that don't expire
- Multi-tenant data with no partition enforcement
- Admin actions with no audit trail
- Sensitive operations with no second-factor requirement

**Fix:** Threat model before you build. Apply defense in depth. Every sensitive operation should have: authentication, authorization, rate limiting, and audit logging.

---

## A05 — Security Misconfiguration

**What it is:** Default credentials, overly permissive configurations, unnecessary features enabled, missing hardening.

**Code patterns to look for:**
- Default admin credentials unchanged
- Debug mode enabled in production: `DEBUG=True`, stack traces exposed to users
- CORS set to `*` (allow all origins)
- Unnecessary HTTP methods enabled (DELETE, TRACE)
- Error responses that expose stack traces or internal paths to the client
- S3 buckets or cloud storage set to public

**Fix:** Disable debug mode in production. Restrict CORS to known origins. Return generic error messages to clients; log details server-side. Automate configuration audits.

---

## A06 — Vulnerable and Outdated Components

**What it is:** Using libraries or frameworks with known security vulnerabilities.

**Code patterns to look for:**
- `package.json`, `requirements.txt`, `pom.xml` with pinned-old versions
- No dependency audit in CI pipeline
- `npm audit` or `pip-audit` showing HIGH/CRITICAL findings
- No process for responding to CVE notifications

**Fix:** Run `npm audit`, `pip-audit`, `bundler-audit`, or Dependabot in CI. Subscribe to security advisories for your critical dependencies. Patch CVEs within SLA (CRITICAL: 24h, HIGH: 1 week).

---

## A07 — Identification and Authentication Failures

**What it is:** Weaknesses in authentication that allow identity spoofing, session hijacking, or brute-force attacks.

**Code patterns to look for:**
- No rate limiting on `/login` endpoint
- Session tokens in URLs (logged in access logs)
- Session IDs not rotated after login (session fixation)
- JWTs with `alg: none` accepted
- Weak password policy (no minimum length, common passwords allowed)
- Passwords stored reversibly (encryption instead of hashing)

**Fix:** Hash passwords with bcrypt/Argon2. Rate-limit auth endpoints. Rotate session IDs on login. Validate JWT algorithm explicitly. Implement account lockout after N failures.

---

## A08 — Software and Data Integrity Failures

**What it is:** Code or data that is used without integrity verification — untrusted deserialization, insecure CI/CD pipelines, unsigned dependencies.

**Code patterns to look for:**
- Deserializing untrusted data with `pickle`, `yaml.load` (unsafe), `ObjectInputStream`
- Auto-update mechanisms without signature verification
- CI/CD secrets in environment variables accessible to pull request builds
- Third-party scripts loaded without Subresource Integrity (SRI) hashes

**Fix:** Use safe deserialization (`yaml.safe_load`, avoid pickle for untrusted input). Verify signatures on packages. Protect CI secrets from fork PRs. Add SRI to CDN-loaded scripts.

---

## A09 — Security Logging and Monitoring Failures

**What it is:** Insufficient logging of security events, making breaches undetectable.

**Code patterns to look for:**
- Failed login attempts not logged
- No log for access control failures
- Logs not centralized (lost on server failure)
- No alerting on suspicious patterns (mass failed logins, unusual data access)
- PII or credentials logged inadvertently

**Fix:** Log all auth events (success and failure), access control failures, and sensitive operations. Include timestamp, user ID, source IP, action. Alert on anomalies. Never log passwords, tokens, or full card numbers.

---

## A10 — Server-Side Request Forgery (SSRF)

**What it is:** The server is tricked into making requests to internal resources on behalf of an attacker.

**Code patterns to look for:**
```python
# Bad — user controls the URL
url = request.params['url']
response = requests.get(url)  # attacker sends: http://169.254.169.254/latest/meta-data/

# Also look for: webhooks, PDF generators, URL preview features
```

**Fix:** Validate and allowlist URL schemes and hosts. Block requests to private IP ranges (10.x, 172.16.x, 192.168.x, 169.254.x). Disable redirects or validate redirect destinations.

---

## Additional Security Checks

### Hardcoded Secrets

**Detection signal:**
```python
API_KEY = "sk-1234abcd..."         # hardcoded key
password = "admin123"              # hardcoded credential
SECRET = "my-jwt-secret"           # hardcoded signing secret
```

Also check for keys in config files committed to git. Use `git log -p | grep -E "(secret|key|password|token)\s*=\s*['\"]"`.

**Fix:** Use environment variables or a secrets manager. Add `.env` to `.gitignore`. Rotate any secrets that were committed.

---

### Sensitive Data in Logs

**Detection signal:**
```python
logger.info(f"User {user.email} authenticated with password {password}")
logger.debug(f"Payment: {card_number} {cvv}")
logger.info(f"Token issued: {access_token}")
```

**Fix:** Never log passwords, full card numbers, CVVs, SSNs, access tokens, or session IDs. Log user IDs and event types, not sensitive values.

---

### Missing Authorization Checks

**Detection signal:** Route handler that reads from session/JWT to get user identity but never checks whether that user has permission to access the resource being requested.

```python
# Bad — authenticates but doesn't authorize
@app.get("/admin/users")
def list_all_users(current_user = Depends(get_current_user)):
    return db.query(User).all()  # any authenticated user can call this

# Good
@app.get("/admin/users")
def list_all_users(current_user = Depends(require_admin)):
    return db.query(User).all()
```

**Fix:** Separate authentication (who are you?) from authorization (what can you do?). Apply authorization middleware or decorators to every protected route.

---

### Insecure Defaults

**Detection signal:**
- Debug mode on by default
- All CORS origins allowed by default
- Admin panel accessible without additional auth
- Rate limiting disabled in configuration
- Verbose error responses in production config

**Fix:** Production configuration should be the secure default. Require explicit opt-in to less-secure development conveniences.
