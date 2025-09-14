# 🚀 Solução Rápida - Casa Inteligente

## ❌ **Problema: Docker Desktop não está rodando**

### 🔧 **Solução 1: Script Automático**
```powershell
.\iniciar-docker.ps1
```

### 🔧 **Solução 2: Manual**
1. Pressione `Win + R`
2. Digite: `Docker Desktop`
3. Pressione Enter
4. Aguarde até o ícone da bandeja ficar **verde**
5. Execute novamente: `.\start.ps1`

---

## ❌ **Problema: Porta 3000 em uso**

### 🔧 **Solução:**
```powershell
# Verificar o que está usando a porta
netstat -ano | findstr :3000

# Parar o processo (substitua PID pelo número)
taskkill /PID 1234 /F

# Ou simplesmente continue - o script vai perguntar se quer continuar
```

---

## ❌ **Problema: Erro de conectividade Docker**

### 🔧 **Solução:**
1. **Reinicie o Docker Desktop**
2. **Aguarde 2-3 minutos** para carregar completamente
3. **Execute diagnóstico:**
   ```powershell
   .\diagnostico.ps1
   ```

---

## ❌ **Problema: Arquivo secrets.yaml não encontrado**

### 🔧 **Solução:**
```powershell
# Copiar arquivo de exemplo
copy config\secrets.yaml.example config\secrets.yaml

# Editar com suas chaves de API
notepad config\secrets.yaml
```

---

## ❌ **Problema: Serviços não iniciam**

### 🔧 **Solução:**
```powershell
# Parar tudo
docker-compose down

# Limpar sistema
docker system prune -f

# Tentar novamente
.\start.ps1
```

---

## ❌ **Problema: Erro de permissões**

### 🔧 **Solução:**
```powershell
# Executar PowerShell como Administrador
# Clique direito no PowerShell > "Executar como administrador"

# Ou executar este comando
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## ✅ **Verificar se está funcionando**

### 🌐 **Acessos:**
- **Home Assistant**: https://casa-inteligente.local:8123
- **Grafana**: https://grafana.casa-inteligente.local:3000

### 📋 **Comandos úteis:**
```powershell
# Ver status dos serviços
docker-compose ps

# Ver logs
docker-compose logs homeassistant

# Reiniciar
docker-compose restart
```

---

## 🆘 **Ainda com problemas?**

### 🔍 **Execute diagnóstico completo:**
```powershell
.\diagnostico.ps1
```

### 📞 **Comandos de emergência:**
```powershell
# Parar tudo e limpar
docker-compose down -v
docker system prune -a -f

# Reinstalar do zero
.\start.ps1
```

---

## 🎯 **Ordem de execução recomendada:**

1. **Iniciar Docker Desktop:**
   ```powershell
   .\iniciar-docker.ps1
   ```

2. **Executar diagnóstico:**
   ```powershell
   .\diagnostico.ps1
   ```

3. **Instalar Casa Inteligente:**
   ```powershell
   .\start.ps1
   ```

4. **Verificar funcionamento:**
   - Acesse: https://casa-inteligente.local:8123
   - Configure o Home Assistant na primeira execução

---

## 💡 **Dicas importantes:**

- ⏰ **Aguarde** - O Docker Desktop demora alguns minutos para carregar
- 🔄 **Reinicie** - Se algo não funcionar, reinicie o Docker Desktop
- 📁 **Configure** - Edite `config/secrets.yaml` com suas chaves de API
- 🌐 **Hosts** - O script configura automaticamente os hosts locais
- 🔒 **SSL** - Certificados auto-assinados são gerados automaticamente

---

**🏠 Sua casa inteligente está quase pronta! ✨**
