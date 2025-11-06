# --- Estágio de Build ---
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /App

# 1. Copiar o .sln
COPY *.sln .

# 2. Copiar CADA diretório de projeto referenciado pelo .sln
# O erro mostrou que precisamos destes quatro:
COPY LoLChampionsAPI.Dominio/ ./LoLChampionsAPI.Dominio/
COPY LoLChampionsAPI.Aplicacao/ ./LoLChampionsAPI.Aplicacao/
COPY LoLChampionsAPI.Infra/ ./LoLChampionsAPI.Infra/

# 3. Restaurar dependências
# Agora o restore vai encontrar todos os .csproj
RUN dotnet restore

# 4. Copiar o restante do código-fonte
COPY . .

# 5. Publicar a aplicação (especificando o projeto de "entrada", que é a API)
RUN dotnet publish "LoLChampionsAPI.API/LoLChampionsAPI.API.csproj" -c Release -o /App/out

# --- Estágio de Runtime (Imagem final) ---
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build /App/out .

# 6. Definir o Entrypoint para a DLL da API
ENTRYPOINT ["dotnet", "LoLChampionsAPI.API.dll"]
