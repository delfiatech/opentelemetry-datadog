FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Get DataDog Dependencies
#ENV TRACER_VERSION 1.23.0
#RUN mkdir -p /opt/datadog
#RUN curl -L https://github.com/DataDog/dd-trace-dotnet/releases/download/v$TRACER_VERSION/datadog-dotnet-apm-${TRACER_VERSION}-musl.tar.gz | tar xzf - -C /opt/datadog

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out

#############################################
############## Build Final Image ############
#############################################

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine

# Copy Data Dog Dependencies
#COPY --from=build-env /opt/datadog /opt/datadog

# Copy Sample Assemblies
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "WebApi.OpenTelemetry.DataDog.dll"]