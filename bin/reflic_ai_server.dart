import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:reflic_ai_server/webHandler.dart';
import 'package:relic/relic.dart';

Future<void> main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  // Setup the app.
  final app = RelicApp();

  // Endpoint handles POST-only requests for image generation
  app.get('/imageGen', imageGeneration);

  // Middleware on all paths below '/'.
  app.use('/', logRequests());

  // Custom fallback - optional (default is 404 Not Found).
  app.fallback = respondWith(
    (_) => Response.notFound(body: Body.fromString("Resource not found.\n")),
  );

  final portValue = env['PORT'] ?? Platform.environment['PORT'];
  final parsedPort = int.tryParse(portValue ?? '') ?? 8080;
  final host = env['HOST']?.isNotEmpty == true ? env['HOST']! : '0.0.0.0';

  // Start the server (defaults to using port 8080).
  await app.serve(address: host, port: parsedPort);
}
