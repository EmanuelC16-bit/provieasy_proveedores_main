class Message {
  final String messageId;
  final String contractId;
  final String senderId;
  final String receiverId;
  final String message;
  final String sentDate;
  final int status; // 1 = sent, 2 = read

  Message({
    required this.messageId,
    required this.contractId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.sentDate,
    required this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['message_id'] ?? '',
      contractId: json['contract_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      message: json['message'] ?? '',
      sentDate: json['sent_date'] ?? '',
      status: json['status'] ?? 1,
    );
  }
}
