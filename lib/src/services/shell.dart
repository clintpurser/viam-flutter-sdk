import 'dart:io';

import 'package:grpc/grpc_connection_interface.dart';
import 'package:viam_sdk/src/gen/service/shell/v1/shell.pbgrpc.dart';

import '../../protos/common/common.dart';
import '../../protos/service/shell.dart';
import '../resource/base.dart';
import '../robot/client.dart';
import '../utils.dart';

class ShellClient extends Resource implements ResourceRPCClient {
  static const Subtype subtype = Subtype(resourceNamespaceRDK, resourceTypeService, 'shell');

  @override
  final String name;

  @override
  ClientChannelBase channel;

  @override
  ShellServiceClient get client => ShellServiceClient(channel);

  ShellClient(this.name, this.channel);

  Future<void> shell() async {
    throw UnimplementedError();

    final request = Stream.value(ShellRequest());
    client.shell(request);
  }

  Future<void> copyFilesToMachine() async {
    throw UnimplementedError();

    final request = Stream.value(CopyFilesToMachineRequest());
    client.copyFilesToMachine(request);
  }

  Future<List<File>> copyFilesFromMachine(String name, List<String> paths, bool allowRecursion, bool preserve) async {
    final metadata = CopyFilesFromMachineRequestMetadata(
      name: name,
      paths: paths,
      allowRecursion: allowRecursion,
      preserve: preserve,
    );

    final request = Stream.value(CopyFilesFromMachineRequest(metadata: metadata));
    final responses = client.copyFilesFromMachine(request);
    try {
      await for (final response in responses) {
        print(response);
        if (response.fileData.eof) print('eof');
        print(response.fileData.data);
      }
    } catch (e) {
      print(e);
    }

    return [];
  }

  @override
  Future<Map<String, dynamic>> doCommand(Map<String, dynamic> command) async {
    final request = DoCommandRequest()
      ..name = name
      ..command = command.toStruct();
    final response = await client.doCommand(request);
    return response.result.toMap();
  }

  /// Get the [ResourceName] for this [ShellClient] with the given [name]
  static ResourceName getResourceName(String name) {
    return ShellClient.subtype.getResourceName(name);
  }

  /// Get the [ShellClient] named [name] from the provided robot.
  static ShellClient fromRobot(RobotClient robot, String name) {
    return robot.getResource(ShellClient.getResourceName(name));
  }
}
