## Relic AI Server

Relic Web Server is Dart based, to create fast prototyping of backend endpoints. Here I have createdAPI endpoints which generates images using Gemini AI Apis

### Local development

```
dart pub get
dart bin/reflic_ai_server.dart
```

Set environment variables such as `GOOGLE_API_KEY`, `HOST`, and `PORT` before running. The server defaults to `0.0.0.0:8080`.

### Container image

Build and test the Docker image locally:

```
docker build -t reflic-ai-server .
docker run --rm -p 8080:8080 -e GOOGLE_API_KEY=... reflic-ai-server
```

### Deploy to Google Cloud Run

```
gcloud builds submit --tag gcr.io/PROJECT_ID/reflic-ai-server
gcloud run deploy reflic-ai-server \
	--image gcr.io/PROJECT_ID/reflic-ai-server \
	--platform managed \
	--region REGION \
	--allow-unauthenticated \
	--set-env-vars "GOOGLE_API_KEY=..."
```

Cloud Run injects the `PORT` environment variable automatically, which the app now respects.
