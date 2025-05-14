import 'package:flutter/material.dart';
import 'package:provieasy_proveedores_main/models/message.dart';
import 'package:provieasy_proveedores_main/services/provieasy_base_service.dart';

class MessageService {
  static Future<List<Message>> fetchMessages(BuildContext context, String contractId) async {
    final response = await ProvieasyBaseService.callListApi(
      context,
      "GetMessages",
      ["message_id", "contract_id", "sender_id", "receiver_id", "message", "sent_date", "status"],
      {"contract_id": contractId},
      200,
    );

    return response.items.map((raw) => Message.fromJson(raw)).toList();
  }

  static Future<Map<String, Message>> fetchUnreadMessagesByContractId(BuildContext context, String receiverId) async {
    final response = await ProvieasyBaseService.callListApi(
      context,
      "GetMessages",
      ["message_id", "contract_id", "sender_id", "receiver_id", "message", "sent_date", "status"],
      {
        "receiver_id": receiverId,
        "status": 1
      },
      200,
    );

    final List<Message> messages = response.items.map((raw) => Message.fromJson(raw)).toList();

    final Map<String, Message> unreadMessagesByContractId = {};

    for (final message in messages) {
      final contractId = message.contractId;
      final current = unreadMessagesByContractId[contractId];

      if (current == null) {
        unreadMessagesByContractId[contractId] = message;
      }
    }

    return unreadMessagesByContractId;
  }

  static Future<int> getCountUnreadMessagesByReceiverId(BuildContext context, String receiverId) async {
    final response = await ProvieasyBaseService.callListApi(
      context,
      "GetMessages",
      [],
      {
        "receiver_id": receiverId,
        "status": 1
      },
      200,
    );
    return response.totalCount;
  }

  static Future<Message> sendMessage(BuildContext context, String contractId, String senderId, String receiverId, String messageText) async {
    final rawMessage = await ProvieasyBaseService.callGetOneApi(
      context,
      "CreateMessage",
      ["message_id", "contract_id", "sender_id", "receiver_id", "message", "status"],
      {
        "contract_id": contractId,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": messageText,
      },
      200,
    );

    return Message.fromJson(rawMessage);
  }

  static Future<void> markMessageAsRead(BuildContext context, String messageId) async {
    await ProvieasyBaseService.callGetOneApi(
      context,
      "ReadMessage",
      ["message_id", "status"],
      {"message_id": messageId},
      200,
    );
  }
}
