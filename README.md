# 💾 Backup Incremental Semanal com Robocopy

Script `.bat` para automação de backup semanal dos arquivos de produção para HD externo offsite, utilizando **Robocopy** e **Agendador de Tarefas do Windows**.

---

## 🎯 Objetivo

Garantir a segurança dos arquivos de produção com uma cópia semanal em dispositivo externo localizado fisicamente em outro prédio (offsite), reduzindo o risco de perda por falha de hardware, incêndio ou outros incidentes.

---

## 🔄 Como funciona

```
[Servidor - Rede]          [HD Externo - Almoxarifado]
     G:\BCK         →  Robocopy incremental  →      D:\
```

1. Todo **HD externo** é conectado ao servidor às sextas-feiras
2. O **Agendador de Tarefas** dispara o script automaticamente no horário do almoço
3. O Robocopy copia apenas arquivos **novos ou modificados** (`/XO`) — backup incremental
4. Um **log com data e hora** é gerado automaticamente em `C:\BCK_LOGs\`
5. O script **verifica se o disco G: está acessível** antes de iniciar — encerra com segurança caso não esteja
6. Logs com mais de **30 dias são deletados automaticamente** via `forfiles`

---

## ⚙️ Configuração

Edite os caminhos no comando robocopy conforme seu ambiente:

```bat
robocopy "G:\BCK" "D:" ...   :: Origem e destino
```

> **Atenção:** Verifique as letras de unidade (`G:\` e `D:\`) — elas podem variar conforme o servidor e o HD conectado.

---

## 📋 Parâmetros do Robocopy utilizados

| Parâmetro   | Função |
|-------------|--------|
| `/E`        | Copia subpastas, incluindo as vazias |
| `/XO`       | Copia apenas arquivos novos ou modificados (incremental) |
| `/MT:16`    | Usa 16 threads simultâneas para cópia mais rápida |
| `/FFT`      | Tolerância de 2s na comparação de timestamps (compatibilidade FAT/NTFS) |
| `/R:3`      | Tenta novamente 3 vezes em caso de falha |
| `/W:5`      | Aguarda 5 segundos entre tentativas |
| `/NP`       | Não exibe percentual de progresso (log mais limpo) |
| `/LOG+`     | Grava log detalhado em modo append |
| `/COPY:DAT` | Copia Dados, Atributos e Timestamps dos arquivos |
| `/DCOPY:T`  | Copia Timestamps das pastas |
| `/J`        | Cópia sem buffer — recomendado para arquivos grandes |

---

## 🗂️ Estrutura de logs

Cada execução gera um arquivo de log com data e hora:

```
C:\BCK_LOGs\
├── backup_10042025_120001.log
├── backup_17042025_120003.log
└── backup_24042025_120002.log
```

> Logs com mais de 30 dias são removidos automaticamente pelo `forfiles`.

---

## 🕐 Agendamento (Task Scheduler)

1. Abrir **Agendador de Tarefas** (`taskschd.msc`)
2. Criar nova tarefa básica
3. **Gatilho:** Semanalmente → Sexta-feira → horário do almoço
4. **Ação:** Iniciar programa → caminho completo do `backup_semanal.bat`
5. Marcar: *Executar independentemente do logon do usuário*
6. Marcar: *Executar com privilégios mais altos*

---

## 📊 Códigos de saída do Robocopy

| Código | Significado |
|--------|-------------|
| 0      | Nenhum arquivo copiado (destino já atualizado) |
| 1      | Arquivos copiados com sucesso |
| 2      | Arquivos extras no destino |
| 3      | Cópia realizada com êxito |
| 4+     | Erros — verificar log |

---

## 🛠️ Tecnologias

![Windows Server](https://img.shields.io/badge/Windows_Server-0078D6?style=flat&logo=windows&logoColor=white)
![BAT Script](https://img.shields.io/badge/Script-.BAT-121011?style=flat&logo=gnu-bash&logoColor=white)
![Robocopy](https://img.shields.io/badge/Robocopy-gray?style=flat&logo=microsoft&logoColor=white)

---

## 👩‍💻 Autora

**Raiane Lage de Moura** — Técnica de Informática  
[raianemourr@gmail.com](mailto:raianemourr@gmail.com)
