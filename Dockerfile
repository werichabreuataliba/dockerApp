FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["DocekrApp.csproj", ""]
RUN dotnet restore "/DocekrApp.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "DocekrApp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DocekrApp.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DocekrApp.dll"]