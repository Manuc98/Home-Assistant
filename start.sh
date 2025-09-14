#!/bin/bash

# Script de Inicialização da Casa Inteligente
# Automatiza o processo de configuração e inicialização

echo "🏠 Iniciando Casa Inteligente - Home Assistant"
echo "=============================================="

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log com timestamp
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

# Função para erro
error() {
    echo -e "${RED}[ERRO]${NC} $1"
}

# Função para sucesso
success() {
    echo -e "${GREEN}[SUCESSO]${NC} $1"
}

# Função para aviso
warning() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

# Verificar se Docker está instalado
log "Verificando dependências..."
if ! command -v docker &> /dev/null; then
    error "Docker não está instalado. Instale o Docker primeiro."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    error "Docker Compose não está instalado. Instale o Docker Compose primeiro."
    exit 1
fi

success "Docker e Docker Compose encontrados"

# Verificar se o arquivo secrets.yaml existe
if [ ! -f "config/secrets.yaml" ]; then
    warning "Arquivo secrets.yaml não encontrado"
    log "Criando arquivo de exemplo..."
    
    cat > config/secrets.yaml << EOF
# Arquivo de Segredos - Casa Inteligente
# IMPORTANTE: Configure suas chaves de API aqui!

# MQTT
mqtt_username: admin
mqtt_password: sua_senha_mqtt_aqui

# Telegram
telegram_api_key: seu_bot_token_telegram_aqui
telegram_chat_id: seu_chat_id_telegram_aqui

# Email
email_sender: seu_email@gmail.com
email_username: seu_email@gmail.com
email_password: sua_senha_app_gmail_aqui
email_recipient: seu_email_destinatario@gmail.com

# OpenWeatherMap
openweather_api_key: sua_chave_openweathermap_aqui

# Forecast Solar
forecast_solar_api_key: sua_chave_forecast_solar_aqui

# Google
google_client_id: seu_client_id_google_aqui
google_client_secret: seu_client_secret_google_aqui

# InfluxDB
influxdb_password: homeassistant123

# Backup
backup_password: sua_senha_backup_aqui

# WiFi credentials (para dispositivos IoT)
wifi_ssid: seu_wifi_ssid
wifi_password: sua_senha_wifi

# Chaves de API adicionais
spotify_client_id: seu_spotify_client_id
spotify_client_secret: seu_spotify_client_secret

# Integração com bancos
bank_api_key: sua_chave_api_banco_aqui

# Serviços de emergência
emergency_contact: +351912345678
police_number: 112
fire_number: 112
medical_number: 112
EOF
    
    warning "Arquivo secrets.yaml criado. Configure suas chaves de API antes de continuar."
    warning "Pressione Enter após configurar o arquivo secrets.yaml..."
    read
fi

# Criar diretórios necessários
log "Criando estrutura de diretórios..."
mkdir -p config/www
mkdir -p config/custom_components
mkdir -p mosquitto/data
mkdir -p mosquitto/log
mkdir -p zigbee2mqtt/data
mkdir -p zigbee2mqtt/log
mkdir -p influxdb/data
mkdir -p influxdb/config
mkdir -p grafana/data
mkdir -p nginx/ssl

success "Estrutura de diretórios criada"

# Configurar permissões
log "Configurando permissões..."
chmod 755 config
chmod 755 config/www
chmod 755 mosquitto/data
chmod 755 mosquitto/log
chmod 755 zigbee2mqtt/data
chmod 755 zigbee2mqtt/log
chmod 755 influxdb/data
chmod 755 influxdb/config
chmod 755 grafana/data

success "Permissões configuradas"

# Gerar certificados SSL auto-assinados (para desenvolvimento)
if [ ! -f "nginx/ssl/casa-inteligente.crt" ]; then
    log "Gerando certificados SSL auto-assinados..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout nginx/ssl/casa-inteligente.key \
        -out nginx/ssl/casa-inteligente.crt \
        -subj "/C=PT/ST=Lisbon/L=Lisbon/O=Casa Inteligente/CN=casa-inteligente.local"
    
    success "Certificados SSL gerados"
else
    log "Certificados SSL já existem"
fi

# Verificar se as portas estão disponíveis
log "Verificando portas disponíveis..."
ports=(80 443 8123 1883 8086 3000 8080 9001)
for port in "${ports[@]}"; do
    if netstat -tuln | grep -q ":$port "; then
        warning "Porta $port já está em uso"
    else
        success "Porta $port disponível"
    fi
done

# Parar containers existentes
log "Parando containers existentes..."
docker-compose down

# Construir e iniciar os serviços
log "Construindo e iniciando serviços..."
docker-compose up -d --build

# Aguardar serviços iniciarem
log "Aguardando serviços iniciarem..."
sleep 30

# Verificar status dos serviços
log "Verificando status dos serviços..."
docker-compose ps

# Verificar logs do Home Assistant
log "Verificando logs do Home Assistant..."
if docker-compose logs homeassistant | grep -q "Home Assistant initialized"; then
    success "Home Assistant inicializado com sucesso"
else
    warning "Home Assistant pode estar ainda inicializando..."
fi

# Configurar hosts locais (opcional)
log "Configurando hosts locais..."
if ! grep -q "casa-inteligente.local" /etc/hosts; then
    echo "127.0.0.1 casa-inteligente.local" | sudo tee -a /etc/hosts
    echo "127.0.0.1 grafana.casa-inteligente.local" | sudo tee -a /etc/hosts
    echo "127.0.0.1 zigbee.casa-inteligente.local" | sudo tee -a /etc/hosts
    echo "127.0.0.1 influxdb.casa-inteligente.local" | sudo tee -a /etc/hosts
    success "Hosts locais configurados"
else
    log "Hosts locais já configurados"
fi

# Exibir informações de acesso
echo ""
echo "🎉 Casa Inteligente iniciada com sucesso!"
echo "=========================================="
echo ""
echo "📱 Acessos disponíveis:"
echo "  • Home Assistant: https://casa-inteligente.local:8123"
echo "  • Grafana: https://grafana.casa-inteligente.local:3000"
echo "  • Zigbee2MQTT: https://zigbee.casa-inteligente.local:8080"
echo "  • InfluxDB: https://influxdb.casa-inteligente.local:8086"
echo ""
echo "🔑 Credenciais padrão:"
echo "  • Home Assistant: Configure na primeira execução"
echo "  • Grafana: admin / admin123"
echo "  • InfluxDB: admin / homeassistant123"
echo ""
echo "📋 Comandos úteis:"
echo "  • Ver logs: docker-compose logs -f homeassistant"
echo "  • Parar serviços: docker-compose down"
echo "  • Reiniciar: docker-compose restart"
echo "  • Atualizar: docker-compose pull && docker-compose up -d"
echo ""
echo "⚠️  IMPORTANTE:"
echo "  • Configure suas chaves de API no arquivo config/secrets.yaml"
echo "  • Adicione seus dispositivos IoT através da interface"
echo "  • Configure as automações conforme suas necessidades"
echo ""
echo "📚 Documentação completa disponível no README.md"
echo ""
echo "🚀 Sua casa inteligente está pronta para uso!"
echo ""

# Opção para abrir o navegador
read -p "Deseja abrir o Home Assistant no navegador? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    if command -v xdg-open &> /dev/null; then
        xdg-open "https://casa-inteligente.local:8123"
    elif command -v open &> /dev/null; then
        open "https://casa-inteligente.local:8123"
    else
        log "Abra manualmente: https://casa-inteligente.local:8123"
    fi
fi

echo ""
echo "🏠 Casa Inteligente configurada e rodando!"
echo "   Aproveite sua nova casa inteligente! ✨"
