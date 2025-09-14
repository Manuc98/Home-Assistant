# 🏠 Instalação da Casa Inteligente no Windows

Guia completo para instalar e configurar o sistema de casa inteligente no Windows.

## 📋 Pré-requisitos

### 1. Docker Desktop
1. Baixe o Docker Desktop para Windows: https://www.docker.com/products/docker-desktop
2. Instale e reinicie o computador
3. Abra o Docker Desktop e aguarde a inicialização
4. Verifique se está rodando: `docker --version`

### 2. Git (Opcional)
1. Baixe o Git: https://git-scm.com/download/win
2. Instale com as configurações padrão

## 🚀 Instalação Rápida

### Método 1: Script Automático (Recomendado)
```powershell
# Abra o PowerShell como Administrador
# Navegue até a pasta do projeto
cd E:\Home_Assistant

# Execute o script de instalação
.\start.ps1
```

### Método 2: Instalação Manual
```powershell
# 1. Criar estrutura de diretórios
New-Item -ItemType Directory -Path "config/www" -Force
New-Item -ItemType Directory -Path "config/custom_components" -Force
New-Item -ItemType Directory -Path "mosquitto/data" -Force
New-Item -ItemType Directory -Path "mosquitto/log" -Force
New-Item -ItemType Directory -Path "zigbee2mqtt/data" -Force
New-Item -ItemType Directory -Path "zigbee2mqtt/log" -Force
New-Item -ItemType Directory -Path "influxdb/data" -Force
New-Item -ItemType Directory -Path "influxdb/config" -Force
New-Item -ItemType Directory -Path "grafana/data" -Force
New-Item -ItemType Directory -Path "nginx/ssl" -Force

# 2. Iniciar os serviços
docker-compose up -d --build

# 3. Aguardar inicialização
Start-Sleep -Seconds 60

# 4. Verificar status
docker-compose ps
```

## ⚙️ Configuração Inicial

### 1. Configurar Chaves de API
Edite o arquivo `config/secrets.yaml` com suas credenciais:

```yaml
# Telegram (para notificações)
telegram_api_key: "1234567890:ABCdefGHIjklMNOpqrsTUVwxyz"
telegram_chat_id: "123456789"

# OpenWeatherMap (para previsão do tempo)
openweather_api_key: "sua_chave_openweathermap"

# Google Assistant (para controle por voz)
google_client_id: "seu_client_id.googleusercontent.com"
google_client_secret: "seu_client_secret"

# Spotify (para música)
spotify_client_id: "seu_spotify_client_id"
spotify_client_secret: "seu_spotify_client_secret"
```

### 2. Obter Chaves de API

#### Telegram Bot
1. Abra o Telegram e procure por @BotFather
2. Digite `/newbot` e siga as instruções
3. Copie o token e chat ID

#### OpenWeatherMap
1. Acesse: https://openweathermap.org/api
2. Crie uma conta gratuita
3. Copie sua API key

#### Google Assistant
1. Acesse: https://console.cloud.google.com/
2. Crie um projeto
3. Ative a API do Google Assistant
4. Crie credenciais OAuth 2.0

### 3. Configurar Hosts Locais
Adicione estas linhas ao arquivo `C:\Windows\System32\drivers\etc\hosts`:

```
127.0.0.1 casa-inteligente.local
127.0.0.1 grafana.casa-inteligente.local
127.0.0.1 zigbee.casa-inteligente.local
127.0.0.1 influxdb.casa-inteligente.local
```

## 🌐 Acessos

Após a instalação, acesse:

- **Home Assistant**: https://casa-inteligente.local:8123
- **Grafana**: https://grafana.casa-inteligente.local:3000
- **Zigbee2MQTT**: https://zigbee.casa-inteligente.local:8080
- **InfluxDB**: https://influxdb.casa-inteligente.local:8086

### Credenciais Padrão
- **Grafana**: admin / admin123
- **InfluxDB**: admin / homeassistant123
- **Home Assistant**: Configure na primeira execução

## 🔧 Comandos Úteis

### Gerenciar Serviços
```powershell
# Ver status dos serviços
docker-compose ps

# Ver logs do Home Assistant
docker-compose logs -f homeassistant

# Parar todos os serviços
docker-compose down

# Reiniciar serviços
docker-compose restart

# Atualizar serviços
docker-compose pull
docker-compose up -d
```

### Backup e Restore
```powershell
# Fazer backup manual
docker-compose exec homeassistant python -m homeassistant --script backup

# Restaurar backup
# Copie o arquivo de backup para config/backups/
# Restaure através da interface do Home Assistant
```

## 🛠️ Solução de Problemas

### Porta já em uso
```powershell
# Verificar qual processo está usando a porta
netstat -ano | findstr :8123

# Parar o processo (substitua PID pelo número do processo)
taskkill /PID 1234 /F
```

### Docker não inicia
1. Verifique se o Docker Desktop está rodando
2. Reinicie o Docker Desktop
3. Execute: `docker system prune -f`

### Certificados SSL
```powershell
# Gerar novos certificados SSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx/ssl/casa-inteligente.key -out nginx/ssl/casa-inteligente.crt -subj "/C=PT/ST=Lisbon/L=Lisbon/O=Casa Inteligente/CN=casa-inteligente.local"
```

### Firewall
```powershell
# Permitir portas no firewall
netsh advfirewall firewall add rule name="Home Assistant" dir=in action=allow protocol=TCP localport=8123
netsh advfirewall firewall add rule name="MQTT" dir=in action=allow protocol=TCP localport=1883
netsh advfirewall firewall add rule name="Grafana" dir=in action=allow protocol=TCP localport=3000
```

## 📱 Configuração de Dispositivos

### Adicionar Dispositivos IoT
1. Acesse Home Assistant → Configurações → Integrações
2. Clique em "Adicionar Integração"
3. Procure pelo seu dispositivo
4. Siga as instruções de configuração

### Dispositivos Recomendados
- **Luzes**: Philips Hue, LIFX, Tasmota
- **Sensores**: Xiaomi Aqara, Sonoff
- **Câmeras**: Ring, Arlo, Eufy
- **Climatização**: Nest, Ecobee, Sensibo
- **Entretenimento**: Chromecast, Roku

## 🎯 Próximos Passos

### 1. Configurar Dispositivos
- Adicione suas luzes inteligentes
- Configure sensores de movimento
- Integre câmeras de segurança
- Configure termostatos

### 2. Criar Automações
- Configure a rotina matinal
- Crie cenas de iluminação
- Configure notificações
- Ative modo economia

### 3. Personalizar Dashboard
- Organize as abas conforme sua preferência
- Adicione novos cartões
- Configure gráficos de energia
- Personalize cores e temas

### 4. Configurar Controle por Voz
- Configure Google Assistant
- Configure Alexa (se disponível)
- Teste comandos de voz
- Crie comandos personalizados

## 📞 Suporte

### Recursos Úteis
- **Documentação**: https://www.home-assistant.io/docs/
- **Comunidade**: https://community.home-assistant.io/
- **Integrações**: https://hacs.xyz/

### Logs e Debug
```powershell
# Ver todos os logs
docker-compose logs

# Ver logs específicos
docker-compose logs homeassistant
docker-compose logs mosquitto
docker-compose logs grafana

# Ver logs em tempo real
docker-compose logs -f homeassistant
```

### Comandos de Diagnóstico
```powershell
# Verificar uso de recursos
docker stats

# Verificar espaço em disco
docker system df

# Limpar sistema Docker
docker system prune -a
```

---

## 🎉 Parabéns!

Sua casa inteligente está configurada e pronta para uso! 

### O que você pode fazer agora:
- ✅ Controlar luzes por voz ou app
- ✅ Monitorar temperatura e qualidade do ar
- ✅ Receber notificações de segurança
- ✅ Automatizar rotinas diárias
- ✅ Monitorar consumo de energia
- ✅ Configurar cenas personalizadas

### Exemplos de uso:
- **"Bom dia"** → Acende luzes, abre cortinas, prepara café
- **"Noite de cinema"** → Escurece sala, liga TV, ajusta som
- **"Modo sono"** → Apaga luzes, ativa alarme, ajusta temperatura
- **Chegada em casa** → Liga luzes, desativa alarme, ajusta clima

**Divirta-se com sua nova casa inteligente! 🏠✨**
