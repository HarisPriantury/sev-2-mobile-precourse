import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/job_request_interface.dart';

class GetJobsApiRequest
    implements GetJobsRequestInterface, ApiRequestInterface {
  GetJobsQuery? query;
  List<String>? ids = [];
  List<String>? subscribers = [];

  GetJobsApiRequest({this.query, this.ids, this.subscribers});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    if (query != null) req['queryKey'] = this.query.toString();

    req['constraints'] = {
      'phids': Map<dynamic, dynamic>(),
      'subscribers': {'subscriberPHIDs': Map<dynamic, dynamic>()},
    };

    if (this.ids!.isNotEmpty) {
      var dataIds = Map<String, String>();
      var counter = 0;
      this.ids?.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['phids'] = dataIds;
    }

    if (this.subscribers!.isNotEmpty) {
      var dataSubscribers = Map<String, String>();
      var counter = 0;
      this.subscribers?.asMap().forEach((key, value) {
        if (!dataSubscribers.containsValue(value.toString())) {
          dataSubscribers[(counter++).toString()] = value;
        }
      });
      req['constraints']['subscribers']['subscriberPHIDs'] = dataSubscribers;
    }

    return req;
  }
}

enum GetJobsQuery { upcoming, leads, all }
