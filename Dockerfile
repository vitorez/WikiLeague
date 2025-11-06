FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
EXPOSE 8080

COPY LolChampionsAPI /*.csproj ./LolChampionsAPI/
COPY Dominio/*.csproj ./Domain/
COPY Aplicacao/*.csproj ./aplicacao/
COPY Infra/*.csproj ./Infra

RUN dotnet restore LolChampionsAPI/LolChampionsAPI.csproj

COPY . .

RUN dotnet publish LolChampionsAPI/LolChampionsAPI.csproj -c Release -o /app/publish /p:UseAppHost=false
 
FROM mcr.microsoft.com/dotnet/aspnet:8.0 as runtime 
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "LolChampionsAPI.dll"]
