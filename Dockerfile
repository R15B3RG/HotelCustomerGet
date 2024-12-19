# Stage 1: Build all dependencies
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file
COPY ["HotelCustomerGet.csproj", "./"]

# Restore dependencies
RUN dotnet restore "HotelCustomerGet.csproj"

# Copy the rest of the solution
COPY . .

# Build the project
RUN dotnet build "HotelCustomerGet.csproj" -c Release

# Stage 2: Publish Dystopia
FROM build AS publish
WORKDIR /src
RUN dotnet publish "HotelCustomerGet.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 3: Final runtime image for Dystopia
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "HotelCustomerGet.dll"]