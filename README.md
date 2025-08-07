# LiteLLM Proxy - Coding-Focused AI Models

A pre-configured [LiteLLM](https://github.com/BerriAI/litellm) proxy server with curated OpenRouter models optimized for coding tasks. This setup provides a unified API interface to access multiple state-of-the-art coding models through a single endpoint.

## 🚀 Features

- **Coding-Optimized Models**: Pre-configured with top-performing coding models from OpenRouter
- **Unified API**: Single endpoint compatible with OpenAI API format
- **Production Ready**: Includes PostgreSQL for persistence, Redis for caching, and comprehensive health checks
- **Easy Deployment**: Docker Compose setup with support for Coolify deployments
- **Authentication**: Master key authentication for secure access
- **Request Logging**: Full request/response logging and analytics

## 🤖 Available Models

| Model Name | Provider | Description |
|------------|----------|-------------|
| `qwen3-coder` | Qwen | Advanced coding model with strong performance |
| `gemini-2.5-flash` | Google | Fast, efficient model for quick coding tasks |
| `horizon-beta` | OpenRouter | Cutting-edge experimental coding model |
| `deepseek-chat-v3` | DeepSeek | Specialized in code understanding and generation |
| `gemini-2.5-pro` | Google | High-performance model for complex coding tasks |
| `kimi-k2` | Moonshot AI | Advanced reasoning for code analysis |

## 🛠️ Quick Start with Docker Compose

### 1. Clone and Configure

```bash
git clone <repository-url>
cd litellm-proxy
```

### 2. Set Environment Variables

Create a `.env` file:

```bash
# Required API Keys
OPENROUTER_API_KEY=sk-or-v1-your-openrouter-key-here
LITELLM_MASTER_KEY=sk-your-secure-master-key-here
POSTGRES_PASSWORD=your-secure-postgres-password
```

### 3. Deploy

```bash
# Start all services
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f litellm-proxy
```

### 4. Test the API

```bash
# Health check
curl -H "Authorization: Bearer $LITELLM_MASTER_KEY" http://localhost:4000/health

# List available models
curl -H "Authorization: Bearer $LITELLM_MASTER_KEY" http://localhost:4000/v1/models

# Make a coding request
curl -X POST http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -d '{
    "model": "qwen3-coder",
    "messages": [
      {"role": "user", "content": "Write a Python function to calculate fibonacci numbers"}
    ]
  }'
```

## ☁️ Coolify Deployment

[Coolify](https://coolify.io/) provides an easy way to deploy this stack to any server.

### 1. Import Project

1. In Coolify dashboard, click **New Resource** → **Docker Compose**
2. Choose your Git repository or upload the project
3. Coolify will automatically detect the `docker-compose.yaml`

### 2. Configure Environment Variables

In the Coolify environment settings, add:

```bash
OPENROUTER_API_KEY=sk-or-v1-your-openrouter-key-here
LITELLM_MASTER_KEY=sk-your-secure-master-key-here
POSTGRES_PASSWORD=your-secure-postgres-password
```

### 3. Deploy

1. Click **Deploy** in Coolify
2. Monitor the deployment logs
3. Access your proxy at the assigned domain

### 4. Custom Domain (Optional)

1. Go to **Domains** in your Coolify app
2. Add your custom domain
3. Coolify will automatically handle SSL certificates

## 📊 Usage Examples

### Python with OpenAI SDK

```python
import openai

client = openai.OpenAI(
    base_url="http://localhost:4000",  # or your Coolify domain
    api_key="your-litellm-master-key"
)

response = client.chat.completions.create(
    model="qwen3-coder",
    messages=[
        {"role": "user", "content": "Debug this Python code: print('hello world'"}
    ]
)

print(response.choices[0].message.content)
```

### Curl Examples

```bash
# Code generation
curl -X POST http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -d '{
    "model": "deepseek-chat-v3",
    "messages": [{"role": "user", "content": "Create a REST API with FastAPI"}],
    "temperature": 0.1
  }'

# Code review
curl -X POST http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -d '{
    "model": "gemini-2.5-pro",
    "messages": [{"role": "user", "content": "Review this code for security issues: [your code here]"}]
  }'
```

## 🔧 Configuration

### Model Configuration

Edit `config.yaml` to add/remove models or modify settings:

```yaml
model_list:
  - model_name: your-custom-model
    litellm_params:
      model: openrouter/provider/model-name
      api_key: os.environ/OPENROUTER_API_KEY
```

### Proxy Settings

Key configuration options in `config.yaml`:

- `request_timeout`: Request timeout in seconds (default: 600)
- `cors`: Enable CORS for web requests
- `stream`: Enable streaming responses
- `set_verbose`: Enable detailed logging

## 📈 Monitoring

### Health Checks

- **Proxy**: `GET /health`
- **Models**: `GET /v1/models`
- **Redis**: Built-in health monitoring
- **PostgreSQL**: Built-in health monitoring

### Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f litellm-proxy
docker compose logs -f postgres
docker compose logs -f redis
```

### Database Access

```bash
# Connect to PostgreSQL
docker compose exec postgres psql -U litellm -d litellm

# Connect to Redis
docker compose exec redis redis-cli
```

## 🛡️ Security

- **API Key Authentication**: All requests require the master key
- **Non-root Containers**: All services run as non-root users
- **Network Isolation**: Services communicate through isolated Docker network
- **Data Persistence**: PostgreSQL and Redis data is persisted in Docker volumes

## 🔄 Updates

### Update LiteLLM

```bash
# Rebuild with latest base image
docker compose up -d --build litellm-proxy
```

### Update Configuration

1. Edit `config.yaml`
2. Rebuild and restart: `docker compose up -d --build litellm-proxy`

## 🐛 Troubleshooting

### Common Issues

**Connection Refused**

```bash
# Check if services are running
docker compose ps

# Check logs for errors
docker compose logs litellm-proxy
```

**Authentication Errors**

- Verify `LITELLM_MASTER_KEY` is set correctly
- Ensure the `Authorization: Bearer` header is included

**Model Not Found**

- Check that the model name matches those in `config.yaml`
- Verify your OpenRouter API key has access to the requested models

### Service Management

```bash
# Stop all services
docker compose down

# Stop and remove volumes (⚠️ deletes data)
docker compose down -v

# Rebuild and restart
docker compose up -d --build
```

## 📝 License

This project uses the open-source LiteLLM proxy. Please refer to the [LiteLLM repository](https://github.com/BerriAI/litellm) for licensing information.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes to `config.yaml` or `docker-compose.yaml`
4. Test locally with `docker compose up`
5. Submit a pull request

---

**Need help?** Open an issue or check the [LiteLLM documentation](https://docs.litellm.ai/).