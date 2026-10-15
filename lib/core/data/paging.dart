import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Long lists load one page at a time and "Show more" adds the next page
/// (spec 14: lists paginate). Firestore queries take `.limit(n)`, so only
/// what is shown is read.
const pageSize = 30;

/// Admin lists (keys starting with `admin:`) page by 100: admins search
/// and scan them.
const adminPageSize = 100;

/// How many items list [key] shows, e.g. `notifications` or `chat:<id>`.
/// Starts again at one page when the screen closes.
final listLimitProvider = NotifierProvider.autoDispose.family<ListLimit, int, String>(ListLimit.new);

class ListLimit extends Notifier<int> {
  ListLimit(this.key);
  final String key;

  int get page => key.startsWith('admin:') ? adminPageSize : pageSize;

  @override
  int build() => page;

  void more() => state = state + page;
}

/// A full page came back, so there may be more to show.
bool mayHaveMore(int loaded, int limit) => loaded >= limit;
