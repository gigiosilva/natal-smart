class MQTTConfiguration {
  final String hostname;
  final int port;
  final String clientID;
  final String subsTopic;
  final String pubTopic;

  MQTTConfiguration(
    this.hostname,
    this.port,
    this.clientID,
    this.subsTopic,
    this.pubTopic,
  );
}
