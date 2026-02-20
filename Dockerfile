# syntax=docker/dockerfile:1.6

FROM dart:stable AS build
WORKDIR /app

# Resolve dependencies
COPY pubspec.* ./
RUN dart pub get

# Copy remaining sources and fetch transitive deps
COPY . ./
RUN dart pub get --offline

# Compile the Relic server to a native executable for faster startups
RUN dart compile exe bin/reflic_ai_server.dart -o /app/bin/server

FROM gcr.io/distroless/cc-debian12 AS runtime
WORKDIR /app

# Copy the compiled binary
COPY --from=build /app/bin/server ./server

# Cloud Run sets PORT; default to 8080 when running locally
ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/app/server"]
