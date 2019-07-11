#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/aspnetcore-build:2.0  AS build
WORKDIR /src
COPY ["DocekrApp/DocekrApp.csproj", "DocekrApp/"]
RUN dotnet restore "DocekrApp/DocekrApp.csproj"
COPY . .
WORKDIR "/src/DocekrApp"
RUN dotnet build "DocekrApp.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DocekrApp.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DocekrApp.dll"]