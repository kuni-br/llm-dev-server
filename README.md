# llm-dev-server

**Ambiente de desenvolvimento llama.cpp em processador Intel acessível via REST**

Este projeto fornece um servidor de desenvolvimento para execução de modelos de linguagem (LLMs) utilizando [llama.cpp](https://github.com/ggerganov/llama.cpp), otimizado para processadores Intel e exposto através de uma API REST simples e eficiente. Ideal para testes, prototipagem e integração de LLMs em aplicações sem necessidade de GPU.

## ✨ Funcionalidades
- **Execução otimizada para CPU Intel** com suporte a instruções AVX2 e AVX512.
- **API REST** para inferência, embeddings e gerenciamento de modelos.
- **Containerizado com Docker** para fácil implantação e isolamento.
- **Pronto para desenvolvimento** com hot-reload e configuração via variáveis de ambiente.

## 🛠️ Pré-requisitos
- Docker e Docker Compose instalados
- Processador Intel com suporte a AVX2 (recomendado) ou AVX
- Pelo menos 8 GB de RAM (para modelos pequenos a médios)
- (Opcional) Modelos quantizados do llama.cpp no formato GGUF

## 🚀 Como usar

### 1. Clone o repositório
```bash
git clone https://github.com/kuni-br/llm-dev-server.git
cd llm-dev-server
```
### 2. Configure os modelos
Crie uma pasta models/ no diretório raiz e adicione seus modelos GGUF. Exemplo:
```bash
mkdir models
# Baixe um modelo (exemplo: TinyLlama-1.1B-Chat-v1.0.Q4_K_M.gguf)
wget -P models/ https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf
```
### 3. Inicie o servidor
```bash
docker-compose up -d
```
### 4. Verifique os logs
```bash
docker-compose logs -f
```
## 📡 API REST (planejada)

| Endpoint | Método | Descrição |
|----------|--------|-----------|
| `/v1/completions` | POST | Gera texto a partir de um prompt |
| `/v1/embeddings` | POST | Gera embeddings para um texto |
| `/v1/models` | GET | Lista modelos carregados/disponíveis |
| `/health` | GET | Verifica status do servidor |

### Exemplo de requisição para `/v1/completions`
```bash
curl -X POST http://localhost:8080/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Explique o que é inteligência artificial em uma frase.",
    "max_tokens": 50,
    "temperature": 0.7
  }'
```

## ⚙️ Configuração

As configurações podem ser ajustadas via variáveis de ambiente no arquivo `docker-compose.yml`:

| Variável | Padrão | Descrição |
|----------|--------|-----------|
| `MODEL_PATH` | `/app/models/Phi-3-mini-4k-instruct-q4.gguf` | Caminho para o modelo dentro do container |
| `HOST` | `0.0.0.0` | Endereço de bind do servidor |
| `PORT` | `8080` | Porta de exposição |
| `N_THREADS` | `4` | Número de threads para inferência |
| `CONTEXT_SIZE` | `2048` | Tamanho do contexto em tokens |

## 📁 Estrutura do Projeto
```
llm-dev-server/
├── Dockerfile          # Imagem base com llama.cpp e servidor REST
├── docker-compose.yml  # Orquestração do container
├── .gitignore          # Arquivos ignorados pelo Git
├── models/             # Pasta para modelos GGUF (criar manualmente)
└── README.md           # Este arquivo
```

## 🧪 Desenvolvimento
Para executar em modo desenvolvimento com código-fonte montado:
```bash
docker-compose -f docker-compose.yml up --build
```
O servidor será reiniciado automaticamente ao detectar alterações nos arquivos-fonte (se configurado com volume adequado).

## 🤝 Contribuição
Contribuições são bem-vindas! Siga os passos:
1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

---

**Nota:** Projeto em estágio inicial de desenvolvimento. A API e funcionalidades podem sofrer alterações.