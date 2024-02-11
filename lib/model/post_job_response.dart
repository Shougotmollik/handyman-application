import 'package:handyman_admin_flutter/model/pagination_model.dart';
import 'package:handyman_admin_flutter/model/post_job_data.dart';

class PostJobResponse {
  Pagination? pagination;
  List<PostJobData>? postJobData;

  PostJobResponse({this.pagination, this.postJobData});

  PostJobResponse.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      postJobData = [];
      json['data'].forEach((v) {
        postJobData?.add(PostJobData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    if (postJobData != null) {
      map['data'] = postJobData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
