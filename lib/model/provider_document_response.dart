class ProviderDocumentResponse {
  List<ProviderDocumentData>? data;

  ProviderDocumentResponse({this.data});

  factory ProviderDocumentResponse.fromJson(Map<String, dynamic> json) {
    return ProviderDocumentResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => ProviderDocumentData.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProviderDocumentData {
  String? deletedAt;
  int? documentId;
  String? documentName;
  int? id;
  int? isVerified;
  String? providerDocument;
  int? providerId;

  ProviderDocumentData({this.deletedAt, this.documentId, this.documentName, this.id, this.isVerified, this.providerDocument, this.providerId});

  factory ProviderDocumentData.fromJson(Map<String, dynamic> json) {
    return ProviderDocumentData(
      deletedAt: json['deleted_at'],
      documentId: json['document_id'],
      documentName: json['document_name'],
      id: json['id'],
      isVerified: json['is_verified'],
      providerDocument: json['provider_document'],
      providerId: json['provider_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deleted_at'] = this.deletedAt;
    data['document_id'] = this.documentId;
    data['document_name'] = this.documentName;
    data['id'] = this.id;
    data['is_verified'] = this.isVerified;
    data['provider_document'] = this.providerDocument;
    data['provider_id'] = this.providerId;
    return data;
  }
}
