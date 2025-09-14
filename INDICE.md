# 📁 Índice da Casa Inteligente

Guia rápido para navegar pelos arquivos do projeto.

## 🏗️ Estrutura Principal

### 📋 Arquivos de Configuração Principal
- [`docker-compose.yml`](docker-compose.yml) - Orquestração principal dos serviços
- [`docker-compose.override.yml`](docker-compose.override.yml) - Configurações de desenvolvimento
- [`docker-compose.prod.yml`](docker-compose.prod.yml) - Configurações de produção
- [`Makefile`](Makefile) - Comandos úteis para gerenciar o sistema
- [`.gitignore`](.gitignore) - Arquivos ignorados pelo Git

### 🚀 Scripts de Instalação
- [`start.ps1`](start.ps1) - Script de instalação para Windows (PowerShell)
- [`start.sh`](start.sh) - Script de instalação para Linux/Mac (Bash)

### 📚 Documentação
- [`README.md`](README.md) - Documentação principal do projeto
- [`INSTALACAO_WINDOWS.md`](INSTALACAO_WINDOWS.md) - Guia específico para Windows
- [`CHANGELOG.md`](CHANGELOG.md) - Histórico de mudanças
- [`LICENSE`](LICENSE) - Licença MIT e isenção de responsabilidade
- [`INDICE.md`](INDICE.md) - Este arquivo (índice)

## ⚙️ Pasta Config (Home Assistant)

### 📄 Arquivos de Configuração Principal
- [`configuration.yaml`](config/configuration.yaml) - Configuração principal do Home Assistant
- [`secrets.yaml`](config/secrets.yaml) - Segredos e chaves de API (não commitar)
- [`secrets.yaml.example`](config/secrets.yaml.example) - Exemplo de configuração de segredos

### 🤖 Automações e Scripts
- [`automations.yaml`](config/automations.yaml) - Automações inteligentes da casa
- [`scripts.yaml`](config/scripts.yaml) - Scripts complexos e sequências
- [`scenes.yaml`](config/scenes.yaml) - Cenas pré-definidas para diferentes situações

### 🎨 Interface e Personalização
- [`ui-lovelace.yaml`](config/ui-lovelace.yaml) - Dashboard principal com Lovelace UI
- [`customize.yaml`](config/customize.yaml) - Personalizações de dispositivos
- [`groups.yaml`](config/groups.yaml) - Grupos organizacionais de dispositivos

### 📊 Sensores e Monitoramento
- [`sensors.yaml`](config/sensors.yaml) - Sensores personalizados e cálculos

### 📦 Pacotes Organizados
- [`packages/casa_completa.yaml`](config/packages/casa_completa.yaml) - Configurações completas da casa
- [`packages/voice_control.yaml`](config/packages/voice_control.yaml) - Controle por voz e assistentes
- [`packages/zigbee_devices.yaml`](config/packages/zigbee_devices.yaml) - Dispositivos Zigbee específicos

### 📁 Pastas Auxiliares
- [`custom_components/`](config/custom_components/) - Componentes personalizados
- [`www/`](config/www/) - Arquivos web estáticos

## 🔧 Serviços Auxiliares

### 📡 MQTT (Mosquitto)
- [`mosquitto/config/mosquitto.conf`](mosquitto/config/mosquitto.conf) - Configuração do broker MQTT
- [`mosquitto/config/passwd`](mosquitto/config/passwd) - Senhas dos usuários MQTT
- [`mosquitto/config/acl.conf`](mosquitto/config/acl.conf) - Controle de acesso MQTT
- [`mosquitto/data/`](mosquitto/data/) - Dados persistentes do MQTT
- [`mosquitto/log/`](mosquitto/log/) - Logs do MQTT

### 🌐 Nginx (Proxy Reverso)
- [`nginx/conf.d/homeassistant.conf`](nginx/conf.d/homeassistant.conf) - Configuração do proxy reverso
- [`nginx/ssl/`](nginx/ssl/) - Certificados SSL/TLS

### 📊 Banco de Dados (InfluxDB)
- [`influxdb/config/`](influxdb/config/) - Configurações do InfluxDB
- [`influxdb/data/`](influxdb/data/) - Dados históricos

### 📈 Grafana (Visualização)
- [`grafana/data/`](grafana/data/) - Dados do Grafana

### 🔗 Zigbee2MQTT
- [`zigbee2mqtt/data/`](zigbee2mqtt/data/) - Dados do Zigbee2MQTT
- [`zigbee2mqtt/log/`](zigbee2mqtt/log/) - Logs do Zigbee2MQTT

## 🎯 Como Usar Este Índice

### 🔍 Encontrar Arquivos Rapidamente
1. **Configuração principal**: Veja `docker-compose.yml` e `config/configuration.yaml`
2. **Automações**: Consulte `config/automations.yaml` e `config/scripts.yaml`
3. **Interface**: Verifique `config/ui-lovelace.yaml`
4. **Dispositivos**: Veja `config/packages/` para configurações específicas
5. **Segurança**: Configure `config/secrets.yaml` (copie do `.example`)

### 📖 Documentação por Tópico
- **Instalação**: `README.md` e `INSTALACAO_WINDOWS.md`
- **Comandos**: `Makefile` e scripts de instalação
- **Mudanças**: `CHANGELOG.md`
- **Licença**: `LICENSE`

### 🛠️ Comandos Rápidos
```bash
# Ver ajuda completa
make help

# Instalar sistema
make install

# Iniciar serviços
make start

# Ver logs
make logs

# Fazer backup
make backup
```

### 🌐 Acessos Rápidos
- **Home Assistant**: https://casa-inteligente.local:8123
- **Grafana**: https://grafana.casa-inteligente.local:3000
- **Zigbee2MQTT**: https://zigbee.casa-inteligente.local:8080

### 🔧 Configuração Inicial
1. Copie `config/secrets.yaml.example` para `config/secrets.yaml`
2. Configure suas chaves de API no arquivo `secrets.yaml`
3. Execute `make install` ou `./start.ps1` (Windows)
4. Acesse https://casa-inteligente.local:8123
5. Configure o Home Assistant na primeira execução

### 📱 Funcionalidades Principais
- **Iluminação inteligente** com controle por presença
- **Climatização** com termostatos inteligentes
- **Segurança** com câmeras e sensores
- **Entretenimento** multiroom
- **Controle por voz** (Google Assistant/Alexa)
- **Monitoramento de energia** em tempo real
- **Automações contextuais** baseadas em localização

### 🎨 Personalização
- **Dashboard**: Edite `config/ui-lovelace.yaml`
- **Automações**: Modifique `config/automations.yaml`
- **Cenas**: Ajuste `config/scenes.yaml`
- **Dispositivos**: Personalize `config/customize.yaml`

---

## 📞 Suporte

### 🆘 Precisa de Ajuda?
1. **Consulte a documentação**: `README.md`
2. **Verifique logs**: `make logs`
3. **Reinicie serviços**: `make restart`
4. **Comunidade Home Assistant**: https://community.home-assistant.io/

### 🔄 Atualizações
- **Ver mudanças**: `CHANGELOG.md`
- **Atualizar sistema**: `make update`
- **Fazer backup**: `make backup`

---

**🏠 Casa Inteligente** - Sua casa, sua forma, sua tecnologia! ✨
