# The Build Environment

"Works on my machine" isn't good enough. This chapter covers containerization, reproducibility, and the fundamentals of build environments—not the specific tools, but the principles that make them work.

---

## "Works on My Machine" Is Not a Build System

You've heard this conversation:

**Developer A:** "The tests pass."
**Developer B:** "They fail for me."
**Developer A:** "Works on my machine."

The code is identical. The tests are identical. Why different results?

The **environment** is different:

- Operating system (macOS vs Linux vs Windows)
- Runtime version (Python 3.9 vs 3.11)
- System libraries (different libssl versions)
- Environment variables (different PATH, different configs)
- Installed packages (different global packages)
- File system (case-sensitive vs case-insensitive)
- Line endings (LF vs CRLF)
- Locale settings (UTF-8 vs ASCII defaults)

Code doesn't run in isolation. It runs in an environment. If the environments differ, behavior can differ.

## The Reproducibility Problem

For a build to be reproducible, you need to control:

| Layer | Examples | Typical Variability |
|-------|----------|---------------------|
| **Hardware** | CPU architecture, memory | Usually consistent (x86_64) |
| **OS** | Linux, macOS, Windows | Often varies |
| **OS version** | Ubuntu 20.04 vs 22.04 | Varies, matters more than you'd think |
| **System packages** | openssl, libffi, compilers | Varies by OS and version |
| **Runtime** | Python, Node, Ruby version | Varies unless controlled |
| **Dependencies** | Your lock file | Controlled if you have lock files |
| **Code** | Your source | Controlled by git |
| **Configuration** | Environment variables | Often varies |

Most developers control the bottom two (code and dependencies) and leave the rest to chance.

## Tool Version Management

Before containers, manage runtime versions explicitly.

### The Problem

```bash
# Developer A
$ python --version
Python 3.9.7

# Developer B
$ python --version
Python 3.11.4

# Same code, different behavior
```

### The Solutions

**pyenv (Python):**
```bash
# Install specific version
pyenv install 3.11.4

# Set for this project
pyenv local 3.11.4

# .python-version file created
cat .python-version
3.11.4
```

**nvm (Node):**
```bash
# Install specific version
nvm install 18.17.0

# Use for this project
nvm use 18.17.0

# .nvmrc file
echo "18.17.0" > .nvmrc
```

**mise (multi-language):**
```bash
# Install tools
mise install python@3.11.4
mise install node@18.17.0

# .mise.toml for project
[tools]
python = "3.11.4"
node = "18.17.0"
```

**asdf (multi-language):**
```bash
# .tool-versions
python 3.11.4
nodejs 18.17.0
```

### Commit Your Version Files

```bash
git add .python-version  # or .nvmrc, .mise.toml, .tool-versions
git commit -m "Pin Python version to 3.11.4"
```

Now everyone on the team (and CI) uses the same version.

## Containerization Fundamentals

Containers solve the "works on my machine" problem by packaging the entire environment.

### What Containers Actually Are

Containers aren't virtual machines. They're isolated processes with their own view of the system:

- **Namespaces** — Isolated view of processes, network, filesystem
- **cgroups** — Resource limits (CPU, memory)
- **Union filesystems** — Layered, efficient image storage

The key insight: **it's still Linux running Linux processes**. There's no hypervisor, no emulated hardware. Just isolation.

### What Containers Give You

**Reproducible environments:** The Dockerfile defines exactly what's in the environment. Same Dockerfile → same environment.

**Isolation:** Dependencies inside the container don't conflict with your system. Multiple projects can have different requirements.

**Portability:** If it runs in the container locally, it runs in the container on the server. (Mostly. ARM vs x86 is still a thing.)

**"Works on my machine" that actually transfers:** The machine is the container, and everyone has the same one.

### What Containers Don't Give You

**Security (by default):** Containers share a kernel with the host. Container escapes are possible. Don't run untrusted code in containers expecting safety.

**Simplicity:** You've added a layer, not removed complexity. Now you have container problems in addition to application problems.

**Magic:** If you don't understand the Dockerfile, you don't understand your build. The complexity is still there—it's just in a different file.

## Dockerfile Fundamentals

A Dockerfile defines how to build a container image.

### Basic Structure

```dockerfile
# Start from a base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy dependency files first (layer caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Define how to run
CMD ["python", "main.py"]
```

### Layer Caching

Docker caches layers. Order matters:

```dockerfile
# GOOD: Dependencies change less often than code
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

# BAD: Any code change invalidates dependency cache
COPY . .
RUN pip install -r requirements.txt
```

Put things that change rarely first, things that change often last.

### Base Image Selection

| Use Case | Base Image | Size |
|----------|------------|------|
| Development | `python:3.11` | ~900MB |
| Production | `python:3.11-slim` | ~150MB |
| Minimal | `python:3.11-alpine` | ~50MB |
| Ultra-minimal | `distroless` | ~20MB |

Smaller images have less attack surface and faster transfers. But alpine can have compatibility issues (musl vs glibc).

### Security Basics

```dockerfile
# Pin the base image with digest (not just tag)
FROM python:3.11-slim@sha256:abc123...

# Don't run as root
RUN useradd --create-home appuser
USER appuser

# Don't install unnecessary packages
RUN pip install --no-cache-dir -r requirements.txt

# Don't leave secrets in layers
# (Use build secrets or runtime injection instead)
```

## Multi-Stage Builds

Separate build-time dependencies from runtime:

```dockerfile
# Build stage
FROM python:3.11 AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

COPY . .
RUN python setup.py build

# Runtime stage
FROM python:3.11-slim

# Copy only what's needed
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app/dist /app

WORKDIR /app
CMD ["python", "main.py"]
```

Build tools, compilers, and dev dependencies stay in the build stage. Only runtime requirements go in the final image.

## Docker Compose for Development

For multi-service development, docker-compose defines the stack:

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    volumes:
      - .:/app  # Mount code for live reload
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgres://db:5432/app
    depends_on:
      - db

  db:
    image: postgres:15
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=app
      - POSTGRES_PASSWORD=devpassword

volumes:
  pgdata:
```

```bash
docker-compose up  # Start everything
docker-compose down  # Stop everything
```

## When You Don't Need Containers

Containers add complexity. Not every project needs them.

### Skip Containers When:

- **Single-language, simple dependencies** — Virtual environments are enough
- **Solo development** — The reproducibility benefit is smaller
- **Quick scripts** — Overhead isn't worth it
- **You don't understand them yet** — Learn the fundamentals first

### Use Containers When:

- **Multiple people/environments** — "Works on my machine" keeps happening
- **CI/CD pipelines** — Consistent build environments
- **Complex system dependencies** — Native libraries, specific OS requirements
- **Production deployment** — Immutable, versioned artifacts
- **Polyglot stacks** — Multiple languages with conflicting requirements

## The Hierarchy of Deployment Needs

Not everything needs Kubernetes:

| Level | Solution | When to Use |
|-------|----------|-------------|
| 0 | Script on a server | Single-use, one server |
| 1 | Virtual environment + systemd | Python app, dedicated server |
| 2 | Docker + docker-compose | Multi-service, single host |
| 3 | Managed containers (ECS, Cloud Run) | Need scaling, don't want K8s |
| 4 | Kubernetes | True orchestration needs |

**Most research software never needs to leave Level 2.**

The right question isn't "should I use Kubernetes?" It's "what's the simplest thing that solves my actual problem?"

## The Graybeard's Take

I've watched containerization go from "weird Linux thing" to "default assumption." That's mostly good—the reproducibility benefits are real.

But I've also watched teams adopt containers because it's what you're supposed to do, without understanding what problems containers solve. They end up with all the complexity and none of the benefits.

Containers aren't magic. They're a way to package an environment. If you understand your environment—what versions of what software you need, how they're configured, where the state lives—containers are a convenient way to express that understanding.

If you don't understand your environment, containers just hide your confusion in a Dockerfile. The confusion is still there. Now it's just harder to debug.

Start by understanding what your code needs to run. Document that. Version that. Then decide if containers are the right tool to enforce it.

---

## Quick Reference

### Dockerfile Checklist

- [ ] Pinned base image (with digest for production)
- [ ] Non-root user
- [ ] Minimal base image (slim, alpine, distroless)
- [ ] Multi-stage build if applicable
- [ ] Layer ordering optimized for caching
- [ ] No secrets in image
- [ ] .dockerignore configured

### Environment Reproducibility Layers

| What | How to Control |
|------|---------------|
| OS/Architecture | Base image |
| System packages | Dockerfile RUN apt-get... |
| Runtime version | Base image tag |
| Dependencies | Lock file |
| Code | Git |
| Configuration | Environment variables, config files |

### Development vs Production

| Aspect | Development | Production |
|--------|-------------|------------|
| Base image | Full | Slim/distroless |
| Volume mounts | Yes (live reload) | No |
| Debugging tools | Yes | No |
| Security hardening | Less critical | Essential |
| Image size | Less important | Minimize |
