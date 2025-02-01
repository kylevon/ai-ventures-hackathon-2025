import 'package:flutter/material.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  bool _isOptedIn = false;

  void _toggleOptInStatus() {
    setState(() {
      _isOptedIn = !_isOptedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Connections'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAIMatchingInfo(context),
          const SizedBox(height: 24),
          _buildOptInOutCard(context),
          const SizedBox(height: 24),
          _buildMyConnections(context),
        ],
      ),
    );
  }

  Widget _buildAIMatchingInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'AI-Powered Health Connections',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Our AI system analyzes your:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildBulletPoint(context, 'Daily health inputs and activities'),
            _buildBulletPoint(context, 'Lifestyle patterns and preferences'),
            _buildBulletPoint(context, 'Medical conditions and treatments'),
            const SizedBox(height: 16),
            Text(
              'To connect you with people who share similar health journeys and can provide meaningful support and understanding.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _buildOptInOutCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Connect with Similar Health Journeys',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'If you opt in, our AI will analyze your lifestyle, inputs, and health status to connect you with people on similar health journeys.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(
                _isOptedIn ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              label: Text(
                _isOptedIn
                    ? 'Stop Receiving Connections'
                    : 'Start Receiving Connections',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(_isOptedIn
                        ? 'Opt Out of Health Connections'
                        : 'Opt In to Health Connections'),
                    content: Text(
                      _isOptedIn
                          ? 'By opting out, you will no longer be matched with people who share similar health conditions and lifestyle. Your data will remain private and will not be used for matching.'
                          : 'By opting in, our AI will analyze your health data to connect you with people on similar health journeys. You can opt out at any time.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _toggleOptInStatus();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          _isOptedIn ? 'Opt Out' : 'Opt In',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (_isOptedIn) ...[
              const SizedBox(height: 16),
              Text(
                'You are currently receiving AI-matched connections',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMyConnections(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Previous Connections',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final connections = [
                {
                  'name': 'Sarah M.',
                  'details': 'Similar diet and exercise routine',
                  'lastActive': '2 days ago',
                },
                {
                  'name': 'John D.',
                  'details': 'Recently diagnosed, same medication',
                  'lastActive': '5 days ago',
                },
                {
                  'name': 'Emma W.',
                  'details': 'Matching lifestyle and health goals',
                  'lastActive': '1 week ago',
                },
              ];

              final connection = connections[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.primaries[index],
                  child: Text(
                    connection['name']!.substring(0, 1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(connection['name']!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(connection['details']!),
                    const SizedBox(height: 4),
                    Text(
                      'Last active: ${connection['lastActive']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.message_outlined),
                  onPressed: () {
                    // TODO: Implement messaging functionality
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
