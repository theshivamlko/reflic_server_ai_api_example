import 'package:dotenv/dotenv.dart';
import 'package:reflic_ai_server/webHandler.dart';
import 'package:relic/relic.dart';

Future<void> main() async {
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

  // Start the server (defaults to using port 8080).
  await app.serve();
}
