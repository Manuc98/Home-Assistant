# 🏠 Casa Inteligente - Home Assistant

Sistema completo de casa inteligente baseado no Home Assistant, implementando automações contextuais, controle por voz, monitoramento de energia e interface intuitiva.

## 🌟 Funcionalidades

### 1. Centro de Comando Inteligente
- **Home Assistant** como núcleo central
- **Docker Compose** para fácil deployment
- **Backups automáticos** configurados
- **Comunicação universal** com dispositivos (Zigbee, Z-Wave, Wi-Fi, Bluetooth)

### 2. Iluminação Inteligente
- Controle por presença automático
- Mudança de cor e intensidade baseada na hora
- Cenas pré-definidas (matinal, noturna, cinema, festa)
- Desligamento automático quando não há presença

### 3. Climatização e Conforto
- Termostatos inteligentes por ambiente
- Sensores de qualidade do ar
- Purificadores automáticos
- Controle de temperatura baseado em presença

### 4. Segurança e Monitoramento
- Sistema de alarme completo
- Câmeras integradas
- Sensores de movimento e abertura
- Notificações via Telegram e Email

### 5. Automação Contextual
- Baseada em localização (GPS)
- Baseada em tempo e padrões
- Integração com clima
- Preparação automática da casa

### 6. Entretenimento
- Sistema multiroom
- Integração Spotify
- Cenas de cinema
- Controle de TV e projetores

### 7. Interface Intuitiva
- Dashboard Lovelace com design neutro
- Múltiplas abas organizadas
- Gráficos de consumo
- Status em tempo real

### 8. Eficiência e Sustentabilidade
- Monitoramento de energia
- Cálculo de custos
- Automações de economia
- Relatórios de eficiência

### 9. Controle por Voz
- Integração Google Assistant
- Integração Alexa
- Comandos em português
- Scripts personalizados

## 🚀 Instalação Rápida

### Windows
```powershell
# Execute como Administrador
.\start.ps1
```

### Linux/Mac
```bash
# Execute o script de instalação
./start.sh

# Ou use o Makefile
make install
make start
```

## 🌐 Acessos

- **Home Assistant**: http://localhost:8123
- **Grafana**: http://localhost:3000
- **InfluxDB**: http://localhost:8086

## 📱 Comandos de Voz

- **"Bom dia"** → Rotina matinal completa
- **"Noite de cinema"** → Cenário de cinema
- **"Modo sono"** → Preparar para dormir
- **"Status da casa"** → Relatório completo
- **"Economizar energia"** → Modo economia

## 🔧 Comandos Úteis

```bash
# Ver status dos serviços
docker-compose ps

# Ver logs
docker-compose logs homeassistant

# Reiniciar
docker-compose restart

# Parar tudo
docker-compose down

# Iniciar novamente
docker-compose up -d
```

## 📁 Estrutura do Projeto

```
Home_Assistant/
├── 📋 Configuração Principal
│   ├── docker-compose.yml
│   ├── Makefile
│   └── .gitignore
├── 🚀 Scripts de Instalação
│   ├── start.ps1 (Windows)
│   ├── start.sh (Linux)
│   ├── iniciar-docker.ps1
│   └── diagnostico.ps1
├── 📚 Documentação
│   ├── README.md
│   ├── INSTALACAO_WINDOWS.md
│   ├── SOLUCAO_RAPIDA.md
│   ├── CHANGELOG.md
│   └── INDICE.md
├── ⚙️ Config Home Assistant
│   ├── configuration.yaml
│   ├── automations.yaml
│   ├── scripts.yaml
│   ├── scenes.yaml
│   ├── sensors.yaml
│   ├── ui-lovelace.yaml
│   ├── customize.yaml
│   ├── groups.yaml
│   ├── secrets.yaml.example
│   └── packages/
│       ├── casa_completa.yaml
│       ├── voice_control.yaml
│       └── zigbee_devices.yaml
└── 🔧 Serviços Auxiliares
    ├── mosquitto/ (MQTT)
    ├── nginx/ (Proxy)
    ├── influxdb/ (Banco)
    ├── grafana/ (Visualização)
    └── zigbee2mqtt/ (Zigbee)
```

## 🛠️ Solução de Problemas

### Problemas Comuns

**🐳 Docker Desktop não está rodando**
```powershell
.\iniciar-docker.ps1
```

**🔍 Diagnóstico completo**
```powershell
.\diagnostico.ps1
```

**📋 Verificar logs**
```bash
docker-compose logs homeassistant
```

## 📞 Suporte

### Recursos Úteis
- **Documentação**: [Home Assistant Docs](https://www.home-assistant.io/docs/)
- **Comunidade**: [Home Assistant Community](https://community.home-assistant.io/)
- **Integrações**: [HACS](https://hacs.xyz/)

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

**🏠 Casa Inteligente** - Transformando sua casa em um ambiente verdadeiramente inteligente! ✨