import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_app/core/constants/strings.dart';
import 'package:inventory_app/core/providers/providers.dart';
import 'package:inventory_app/core/utils/utils.dart';
import 'package:inventory_app/data/models/models.dart';
import 'package:restart_app/restart_app.dart';
import 'package:universal_html/html.dart' as html;

class AppwriteConfigForm extends ConsumerStatefulWidget {
  const AppwriteConfigForm({super.key});

  @override
  ConsumerState<AppwriteConfigForm> createState() => _AppwriteConfigFormState();
}

class _AppwriteConfigFormState extends ConsumerState<AppwriteConfigForm> {
  final TextEditingController _endpointController = TextEditingController();
  final TextEditingController _projectIdController = TextEditingController();
  final TextEditingController _databaseIdController = TextEditingController();
  final TextEditingController _collectionIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final appwriteConfig = ref.read(appwriteConfigProvider);

    // Initialize controllers with current config values
    _endpointController.text = appwriteConfig.endpoint;
    _projectIdController.text = appwriteConfig.projectId;
    _databaseIdController.text = appwriteConfig.databaseId;
    _collectionIdController.text = appwriteConfig.collectionId;
  }

  @override
  void dispose() {
    _endpointController.dispose();
    _projectIdController.dispose();
    _databaseIdController.dispose();
    _collectionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentConfig = ref.watch(appwriteConfigProvider);

    return Form(
      onChanged: () {
        setState(() {});
      },
      child: Column(
        children: [
          TextFormField(
            controller: _endpointController,
            decoration: const InputDecoration(
                labelText: DatabaseConfigurationSettings.endpointLabel),
          ),
          TextFormField(
            controller: _projectIdController,
            decoration: const InputDecoration(
                labelText: DatabaseConfigurationSettings.projectIdLabel),
          ),
          TextFormField(
            controller: _databaseIdController,
            decoration: const InputDecoration(
                labelText: DatabaseConfigurationSettings.databaseIdLabel),
          ),
          TextFormField(
            controller: _collectionIdController,
            decoration: const InputDecoration(
                labelText: DatabaseConfigurationSettings.collectionIdLabel),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isDifferentConfig(currentConfig)
                ? () async {
                    final configToTest = AppwriteConfig(
                      endpoint: _endpointController.text.trim(),
                      projectId: _projectIdController.text.trim(),
                      databaseId: _databaseIdController.text.trim(),
                      collectionId: _collectionIdController.text.trim(),
                    );
                    if (await isConfigValid(configToTest)) {
                      // If the form is valid, update the Appwrite configuration
                      await ref
                          .read(appwriteConfigProvider.notifier)
                          .updateConfig(configToTest);

                      // Restart the app
                      if (kIsWeb) {
                        html.window.location.reload();
                      } else {
                        Restart.restartApp(
                            notificationTitle: Messages.appRestartTitle,
                            notificationBody: Messages.appRestartPrompt);
                      }
                    } else {
                      if (context.mounted && mounted) {
                        showErrorSnackBar(
                          context,
                          ErrorInfo(
                            message:
                                SnackBarMessages.appwriteConfigFormSubmitError,
                          ),
                        );
                      }
                    }
                  }
                : null,
            child: const Text(DatabaseConfigurationSettings.submit),
          ),
        ],
      ),
    );
  }

  // Function to check if the new configuration is different
  bool isDifferentConfig(AppwriteConfig currentConfig) {
    final newEndpoint = _endpointController.text;
    final newProjectId = _projectIdController.text;
    final newDatabaseId = _databaseIdController.text;
    final newCollectionId = _collectionIdController.text;

    // Check if all fields are non-empty
    if (newEndpoint.isEmpty ||
        newProjectId.isEmpty ||
        newDatabaseId.isEmpty ||
        newCollectionId.isEmpty) {
      return false;
    }

    // Check if at least one value is different
    return newEndpoint != currentConfig.endpoint ||
        newProjectId != currentConfig.projectId ||
        newDatabaseId != currentConfig.databaseId ||
        newCollectionId != currentConfig.collectionId;
  }
}
