import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app_exam/core/models/network_response.dart';
import 'package:todo_app_exam/core/network/api_client.dart';
import 'package:todo_app_exam/features/home/bloc/home_bloc.dart';
import 'package:todo_app_exam/features/home/bloc/home_event.dart';

void main() {
  test(
    'refresh shows the latest API photos and clears them when the API fails',
    () async {
      final bloc = HomeBloc(
        networkCaller: _QueuedNetworkCaller([
          NetworkResponse(
            isSuccess: true,
            statusCode: 200,
            responseData: {
              'data': [
                {'id': 'photo-1', 'fileSize': 1500000},
              ],
            },
          ),
          NetworkResponse(
            isSuccess: true,
            statusCode: 200,
            responseData: {
              'data': [
                {'id': 'photo-2', 'fileSize': 2500000},
              ],
            },
          ),
          NetworkResponse(
            isSuccess: false,
            statusCode: 401,
            errorMessage: 'Unauthorized Access',
          ),
        ]),
      );

      final firstLoad = bloc.stream.firstWhere(
        (state) => !state.isLoading && state.photos.isNotEmpty,
      );
      bloc.add(const HomeFetchPhotos());
      expect((await firstLoad).photos, hasLength(1));

      final refreshedLoad = bloc.stream.firstWhere(
        (state) => !state.isLoading && state.photos.isNotEmpty,
      );
      bloc.add(const HomeFetchPhotos());
      expect((await refreshedLoad).photos.single.id, 'photo-2');

      final failedRefresh = bloc.stream.firstWhere(
        (state) => !state.isLoading && state.errorMessage.isNotEmpty,
      );
      bloc.add(const HomeFetchPhotos());
      final state = await failedRefresh;

      expect(state.photos, isEmpty);
      await bloc.close();
    },
  );
}

class _QueuedNetworkCaller extends NetworkCaller {
  _QueuedNetworkCaller(this.responses);

  final List<NetworkResponse> responses;

  @override
  Future<NetworkResponse> getRequest({
    required String url,
    String? token,
  }) async {
    return responses.removeAt(0);
  }
}
