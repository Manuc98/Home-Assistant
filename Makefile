# Makefile para Casa Inteligente - Home Assistant
# Comandos úteis para gerenciar o sistema

.PHONY: help install start stop restart logs status backup restore update clean

# Variáveis
COMPOSE_FILE = docker-compose.yml
COMPOSE_DEV = docker-compose.override.yml
COMPOSE_PROD = docker-compose.prod.yml

# Ajuda
help: ## Mostra esta ajuda
	@echo "🏠 Casa Inteligente - Comandos Disponíveis"
	@echo "=========================================="
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

# Instalação e configuração inicial
install: ## Instala e configura o sistema pela primeira vez
	@echo "🚀 Instalando Casa Inteligente..."
	@mkdir -p config/www config/custom_components
	@mkdir -p mosquitto/data mosquitto/log
	@mkdir -p zigbee2mqtt/data zigbee2mqtt/log
	@mkdir -p influxdb/data influxdb/config
	@mkdir -p grafana/data nginx/ssl
	@if [ ! -f config/secrets.yaml ]; then cp config/secrets.yaml.example config/secrets.yaml; fi
	@echo "✅ Instalação concluída!"
	@echo "📝 Configure o arquivo config/secrets.yaml antes de iniciar"

# Iniciar serviços
start: ## Inicia todos os serviços
	@echo "🏠 Iniciando Casa Inteligente..."
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) up -d
	@echo "✅ Serviços iniciados!"
	@echo "🌐 Acesse: https://casa-inteligente.local:8123"

# Iniciar em modo produção
start-prod: ## Inicia serviços em modo produção
	@echo "🏠 Iniciando Casa Inteligente (Produção)..."
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_PROD) up -d
	@echo "✅ Serviços iniciados em modo produção!"

# Parar serviços
stop: ## Para todos os serviços
	@echo "🛑 Parando Casa Inteligente..."
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) down
	@echo "✅ Serviços parados!"

# Reiniciar serviços
restart: ## Reinicia todos os serviços
	@echo "🔄 Reiniciando Casa Inteligente..."
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) restart
	@echo "✅ Serviços reiniciados!"

# Ver logs
logs: ## Mostra logs do Home Assistant
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) logs -f homeassistant

# Ver logs de todos os serviços
logs-all: ## Mostra logs de todos os serviços
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) logs -f

# Status dos serviços
status: ## Mostra status dos serviços
	@echo "📊 Status dos Serviços:"
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) ps

# Backup
backup: ## Faz backup da configuração
	@echo "💾 Fazendo backup..."
	@mkdir -p backups
	@tar -czf backups/casa-inteligente-$(shell date +%Y%m%d_%H%M%S).tar.gz config/
	@echo "✅ Backup salvo em backups/"

# Restaurar backup
restore: ## Restaura backup (especifique BACKUP=arquivo.tar.gz)
	@if [ -z "$(BACKUP)" ]; then echo "❌ Especifique BACKUP=arquivo.tar.gz"; exit 1; fi
	@echo "🔄 Restaurando backup: $(BACKUP)"
	@tar -xzf $(BACKUP)
	@echo "✅ Backup restaurado!"

# Atualizar serviços
update: ## Atualiza todos os serviços
	@echo "🔄 Atualizando serviços..."
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) pull
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) up -d
	@echo "✅ Serviços atualizados!"

# Limpar sistema Docker
clean: ## Limpa containers, volumes e imagens não utilizados
	@echo "🧹 Limpando sistema Docker..."
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) down -v
	docker system prune -f
	docker volume prune -f
	@echo "✅ Sistema limpo!"

# Configurar SSL
ssl: ## Gera certificados SSL auto-assinados
	@echo "🔐 Gerando certificados SSL..."
	@mkdir -p nginx/ssl
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout nginx/ssl/casa-inteligente.key \
		-out nginx/ssl/casa-inteligente.crt \
		-subj "/C=PT/ST=Lisbon/L=Lisbon/O=Casa Inteligente/CN=casa-inteligente.local"
	@echo "✅ Certificados SSL gerados!"

# Configurar hosts locais
hosts: ## Configura hosts locais no sistema
	@echo "🌐 Configurando hosts locais..."
	@echo "127.0.0.1 casa-inteligente.local" | sudo tee -a /etc/hosts
	@echo "127.0.0.1 grafana.casa-inteligente.local" | sudo tee -a /etc/hosts
	@echo "127.0.0.1 zigbee.casa-inteligente.local" | sudo tee -a /etc/hosts
	@echo "127.0.0.1 influxdb.casa-inteligente.local" | sudo tee -a /etc/hosts
	@echo "✅ Hosts locais configurados!"

# Monitorar recursos
monitor: ## Monitora uso de recursos dos containers
	docker stats

# Executar comandos no Home Assistant
exec: ## Executa comando no container do Home Assistant
	@if [ -z "$(CMD)" ]; then echo "❌ Especifique CMD='comando'"; exit 1; fi
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) exec homeassistant $(CMD)

# Verificar configuração
check: ## Verifica configuração do Home Assistant
	@echo "🔍 Verificando configuração..."
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) exec homeassistant python -m homeassistant --script check_config
	@echo "✅ Verificação concluída!"

# Instalar HACS
hacs: ## Instala HACS (Home Assistant Community Store)
	@echo "📦 Instalando HACS..."
	@mkdir -p config/custom_components
	@cd config/custom_components && \
	curl -fsSL https://github.com/hacs/integration/releases/latest/download/hacs.zip -o hacs.zip && \
	unzip -o hacs.zip && \
	rm hacs.zip
	@echo "✅ HACS instalado! Reinicie o Home Assistant."

# Desenvolvimento
dev: ## Inicia em modo desenvolvimento com logs
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) up

# Produção
prod: ## Inicia em modo produção
	docker-compose -f $(COMPOSE_FILE) -f $(COMPOSE_PROD) up -d

# Default target
.DEFAULT_GOAL := help
