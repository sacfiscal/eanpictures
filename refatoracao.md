# Refatoração EAN Pictures - 1a etapa

- [X] Mudar o tipo de aplicação para console
- [ ] Remoção do Main.View.pas
- [X] Migrar para a nova versão do Horse
- [ ] Remover acesso de recursos visuais da API
- [X] Criar uma unit específica para conexão com banco de dados
- [X] Remover Uses do Zeos na classe de conexão com banco de dados
- [ ] Remover Utilização de variáveis globais
- [X] No endpoint /api/desc_ini/:id garantir que a variável seja destruída

# Refatoração EAN Pictures - 2a etapa (melhoria na estrutura do projeto)

- [ ] Organização do projeto em pastas (controllers, providers, services)
- [X] organização e nomeação dos endpoints
- [ ] Passagem de filtros
- [ ] Separar em responsabilidades o conteúdo que está na wsHorse
- [ ] Padronizar Nome de variáveis e parâmetros de funções
- [ ] Blocos try-finally sem necessidade
- [ ] Rever Uso do with
- [X] Manter um padrão na resposta dos dados, uma hora retorna JSON, outra um texto
- [ ] Parâmetro Next não é mais necessário na nova versão do Horse
- [ ] Não precisa ficar criando TJSONPair para cada pair adicionado
- [ ] Uso do FreeAndNil sem necessidade no endpoint /api/desc_ini/:id
- [ ] Identação de código
- [ ] Excluir Componente para fazer requisição