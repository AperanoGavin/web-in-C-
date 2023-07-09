# Utilisez l'image de base avec le SDK .NET pour construire votre application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Définissez le répertoire de travail
WORKDIR /app

# Copiez les fichiers de projet et les restaurer les dépendances
COPY ./www/*.csproj ./
RUN dotnet restore

# Copiez tout le code source
COPY . .

# Construisez l'application web
RUN dotnet build -c Release -o out

# Étape finale : Utilisez une image d'exécution plus légère pour exécuter l'application
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Définissez le répertoire de travail
WORKDIR /app

# Copiez les fichiers de sortie de l'étape de construction
COPY --from=build /app/out .

# Exposez le port sur lequel l'application écoute
EXPOSE 80

# Définissez la commande de démarrage de l'application
ENTRYPOINT ["dotnet", "NomDeVotreProjet.dll"]
