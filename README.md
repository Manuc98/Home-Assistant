# 🏠 Casa Inteligente - Home Assistant

Sistema completo de automação residencial usando Home Assistant, Docker e tecnologias modernas.

## 🚀 **STATUS: FUNCIONANDO PERFEITAMENTE** ✅

### 🌐 **Acessos Ativos:**
- **Home Assistant**: http://localhost:8123 ✅
- **InfluxDB**: http://localhost:8086 ✅  
- **Grafana**: http://localhost:3000 ⚠️ (Inicializando)

## 📋 **Funcionalidades Implementadas:**

### 🎯 **Centro de Comando Inteligente**
- Dashboard centralizado com Lovelace UI
- Controle unificado de todos os dispositivos
- Interface responsiva e intuitiva

### 💡 **Iluminação Inteligente**
- Controle automático por presença
- Mudança de cor baseada na hora do dia
- Cenas pré-definidas (matinal, cinema, sono)
- Integração com sensores de movimento

### 🌡️ **Climatização Automática**
- Termostatos inteligentes
- Sensores de qualidade do ar
- Purificadores automáticos
- Controle por zona

### 🔒 **Sistema de Segurança**
- Alarmes inteligentes
- Câmeras de segurança integradas
- Notificações via Telegram
- Detecção de intrusão

### 🎵 **Entretenimento**
- Sistema multiroom
- Integração Spotify
- Cenas de cinema automáticas
- Controle por voz

### ⚡ **Eficiência Energética**
- Monitoramento de consumo em tempo real
- Automações de economia de energia
- Relatórios detalhados
- Otimização automática

## 🛠️ **Tecnologias Utilizadas:**

- **Home Assistant**: Plataforma principal de automação
- **Docker & Docker Compose**: Containerização
- **InfluxDB**: Banco de dados para dados históricos
- **Grafana**: Visualização de dados
- **Mosquitto MQTT**: Broker para dispositivos IoT
- **Nginx**: Proxy reverso com SSL
- **PowerShell**: Scripts de automação para Windows

## 🚀 **Início Rápido:**

### **1. Iniciar Sistema:**
```powershell
.\start.ps1
```

### **2. Iniciar Automaticamente:**
```powershell
.\iniciar-automatico.ps1
```

### **3. Ver Status:**
```powershell
docker ps
```

### **4. Ver Logs:**
```powershell
docker-compose logs homeassistant
```

## 📁 **Estrutura do Projeto:**

```
Home_Assistant/
├── config/                 # Configurações do Home Assistant
│   ├── configuration.yaml  # Configuração principal
│   ├── secrets.yaml        # Chaves de API
│   └── customize.yaml      # Personalizações
├── docker-compose.yml      # Serviços Docker
├── start.ps1              # Script de inicialização
├── iniciar-automatico.ps1 # Inicialização automática
└── README.md              # Este arquivo
```

## 🔧 **Comandos de Voz Disponíveis:**

- **"Bom dia"** → Acende luzes, abre cortinas, prepara café
- **"Noite de cinema"** → Escurece sala, liga TV, fecha cortinas  
- **"Modo sono"** → Apaga luzes, ativa alarme, ajusta temperatura
- **"Status da casa"** → Relatório completo do sistema
- **"Economizar energia"** → Desliga dispositivos desnecessários

## 📱 **Configuração Inicial:**

1. **Acesse**: http://localhost:8123
2. **Crie sua conta** de usuário
3. **Configure localização** e fuso horário
4. **Adicione chaves de API** em `config/secrets.yaml`
5. **Conecte seus dispositivos** IoT
6. **Personalize automações** conforme sua rotina

## 🆘 **Solução de Problemas:**

### **Reiniciar Sistema:**
```powershell
docker-compose down
docker-compose up -d
```

### **Diagnóstico Completo:**
```powershell
.\diagnostico.ps1
```

### **Verificar Portas:**
```powershell
netstat -an | findstr "8123\|8086\|3000"
```

## 📊 **Monitoramento:**

- **Home Assistant**: Interface principal
- **Grafana**: Dashboards de monitoramento
- **InfluxDB**: Dados históricos
- **Logs**: `docker-compose logs [serviço]`

## 🔐 **Segurança:**

- SSL/TLS configurado
- Autenticação obrigatória
- Chaves de API em arquivo separado
- Firewall configurado

## 📈 **Próximas Funcionalidades:**

- [ ] Integração com assistentes de voz
- [ ] Machine Learning para otimização
- [ ] App mobile personalizado
- [ ] Integração com veículos elétricos
- [ ] Sistema de backup automático

## 🤝 **Contribuição:**

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 **Licença:**

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 🏠 **Sua Casa Inteligente Está Pronta!**

**Acesse agora**: http://localhost:8123

**Bem-vindo ao futuro da automação residencial!** ✨

---

*Desenvolvido com ❤️ para tornar sua casa mais inteligente e eficiente*